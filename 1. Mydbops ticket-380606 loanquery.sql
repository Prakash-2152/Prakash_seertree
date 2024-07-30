select
	loan_number as l_loan_number,
	Transaction_id as l_transaction_id,
	loan_start_date as l_loan_start_date,
	loan_maturity_date as l_loan_maturity_date,
	lender_bank_name as l_lender_bank_name_id,
	sanction_ref_no as l_sanction_ref_no,
	sanction_date as l_sanction_date,
	facility_name as l_facility_name,
	currency as l_currency,
	amount as l_amount,
	exchange_rate as l_exchange_rate,
	loan_in_inr as l_loan_in_inr,
	loan_type as l_loan_type,
	benchmark_rate as l_benchmark_rate,
	spread as l_spread,
	fixed_interest_rate as l_fixed_interest_rate,
	interest_frequency as l_interest_frequency,
	basis as l_basis,
	KBM.status as l_status,
	bank_account_id as l_bank_account_id,
	company_code as l_company_code,
	line_of_business as l_line_of_business,
	loan_classification as l_loan_classification,
	(
	SELECT
		ktdl.name as type_name
	FROM
		KBR_TYPES_DEFINITIONS_LINES ktdl
	WHERE
		1 = 1
		AND ktdl.type_line_id = loan_classification) as l_loan_classification_name,
	interest_acccrued_account as l_interest_acccrued_account,
	interest_expense_account as l_interest_expense_account,
	principal_due_account as l_principal_due_account,
	processing_fees_account as l_processing_fees_account,
	lease_offset_account as l_lease_offset_account,
	(
	select
		facility_name
	from
		KBR_FACILITY_MASTER KL
	WHERE
		KL.FACILITY_ID = KBM.FACILITY_NAME) as l_fac_name,
	KBM.source as l_source,
	level as p_inv_level,
	effective_interest_rate as l_effective_interest_rate,
	processing_fees as l_processing_fees,
	interest_includes as l_int_includes,
	exchange_type as l_exchange_type,
	next_interest_due_date as l_next_interest_due_date,
	interest_type as l_interest_type,
	forex_gain_loss_account as l_forex_gain_loss_account,
	other_charges as l_other_charges,
	init_charges as l_init_charges,
	(
	select
		sum(KL.repay_amount)
	from
		KBR_LOAN_DTL KL
	WHERE
		KL.LOAN_NUMBER = KBM.LOAN_NUMBER) as l_repaid_to_date,
	payment_method as p_payment_method,
	processing_fees_vat,
	init_charges_vat,
	vat_account,
	deferred_account,
	approval_status as approval_status,
	original_loan_number,
	(
	select
		count(*)
	from
		KBR_ATTACHMENTS
	where
		source = 'LOAN'
		and trx_number = loan_number) as attachments_flag,
	(
	select
		sum(KL.AMOUNT) + ifnull(sum(KL.repay_amount), 0)
	from
		KBR_LOAN_DTL KL
	WHERE
		KL.LOAN_NUMBER = KBM.LOAN_NUMBER
		and approval_status not in('Rejected', 'cancelled') ) AS l_loan_balance
from
	KBR_LOAN_DTL KBM,
	KBR_USER_COMPANY KTC
where
	KTC.COMPANY_ID = KBM.COMPANY_CODE
	AND KBM.source = 'LOAN'
	AND KBM.LOAN_START_DATE IS NOT NULL
	AND KTC.user_id = ?
	AND CASE
		when ? = 'Y' then loan_maturity_date >= current_date()
		else loan_maturity_date < current_date()
	end
order by
	KBM.Transaction_id desc