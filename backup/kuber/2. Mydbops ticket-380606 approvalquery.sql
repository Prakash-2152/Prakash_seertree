(
SELECT
    (
    SELECT
        CONCAT_WS(':', bank_code, bank_name) AS THIRD_PARTY_NAME
    FROM
        KBR_THIRD_PARTY
    WHERE
        THIRD_PARTY_ID = KFD.THIRD_PARTY_ID
                ) AS THIRD_PARTY_NAME,
    lien,
    classification,
    FD_START AS start_date,
    FD_MATURITY AS end_date,
    (
    SELECT
        CONCAT_WS(':', bank_name, account_number)
    FROM
        KBR_BANK_MASTER kbr
    WHERE
        kbr.bank_account_id = KFD.FUNDING_BANK_ACCOUNT
            ) AS FUNDING_BANK_ACCOUNT,
    CURRENCY,
    FD_AMOUNT AS amount,
    COMPOUNDING AS INTEREST_FREQUENCY,
    INTEREST_RATE,
    NULL AS BENCHMARK_RATE,
    PURPOSE,
    LEVEL geography,
    (
    SELECT
        company_name
    FROM
        KBR_TREASURY_COMPANY KTC
    WHERE
        KTC.company_id = KBN.company_id
            ) AS company_name,
    company_id,
    trx_id,
    trx_number,
    instrument_type,
    transaction_action,
    NOTIFICATION_ID,
    KBN.creation_date
FROM
    KBR_APPROVAL_NOTIFICATIONS KBN,
    KBR_FIXED_DEPOSITS KFD
WHERE
    KBN.USER_ID = 502
    AND transaction_action = 'INITIAL_CREATION'
    AND current_approver = 'Y'
    AND instrument_type = 'FD'
    AND FD_CERTIFICATE = trx_number
UNION ALL
SELECT
    (
    SELECT
        CONCAT_WS(':', bank_code, bank_name) AS THIRD_PARTY_NAME
    FROM
        KBR_THIRD_PARTY
    WHERE
        THIRD_PARTY_ID = KLD.LENDER_BANK_NAME
            ) AS THIRD_PARTY_NAME,
    NULL AS lien,
    line_of_business AS classification,
    LOAN_START_DATE AS start_date,
    LOAN_MATURITY_DATE AS end_date,
    (
    SELECT
        CONCAT_WS(':', bank_name, account_number)
    FROM
        KBR_BANK_MASTER kbr
    WHERE
        kbr.bank_account_id = KLD.BANK_ACCOUNT_ID ) AS FUNDING_BANK_ACCOUNT,
    CURRENCY,
    AMOUNT,
    INTEREST_FREQUENCY,
    FIXED_INTEREST_RATE AS INTEREST_RATE,
    BENCHMARK_RATE,
    NULL AS PURPOSE,
    NULL AS geography,
    (
    SELECT
        company_name
    FROM
        KBR_TREASURY_COMPANY KTC
    WHERE
        KTC.company_id = KBN.company_id ) AS company_name,
    company_id,
    trx_id,
    trx_number,
    instrument_type,
    transaction_action,
    NOTIFICATION_ID,
    KBN.creation_date
FROM
    KBR_APPROVAL_NOTIFICATIONS KBN,
    KBR_LOAN_DTL KLD
WHERE
    KBN.USER_ID = 502
    AND transaction_action = 'INITIAL_CREATION'
    AND current_approver = 'Y'
    AND loan_number = trx_number
    AND instrument_type IN(
                    'LOAN', 'LOAN_ADV', 'RETAIL_TERM_MONEY', 'RETAIL_ADV'
                )
    AND loan_start_date IS NOT NULL
UNION ALL
SELECT
    (
    SELECT
        CONCAT_WS(':', bank_code, bank_name) AS THIRD_PARTY_NAME
    FROM
        KBR_THIRD_PARTY
    WHERE
        THIRD_PARTY_ID = KLD.LENDER_BANK_NAME
            ) AS THIRD_PARTY_NAME,
    NULL AS lien,
    line_of_business AS classification,
    KLD.REPAY_DATE AS start_date,
    KLD.LOAN_MATURITY_DATE AS end_date,
    (
    SELECT
        CONCAT_WS(':', bank_name, account_number)
    FROM
        KBR_BANK_MASTER kbr
    WHERE
        kbr.bank_account_id = KLD.FUNDING_BANK_ACCOUNT
            ) AS FUNDING_BANK_ACCOUNT,
    KLD.CURRENCY,
    KLD.REPAY_AMOUNT,
    KLD.REPAYMENT_FREQUENCY,
    FIXED_INTEREST_RATE AS INTEREST_RATE,
    BENCHMARK_RATE,
    NULL AS PURPOSE,
    NULL AS geography,
    (
    SELECT
        company_name
    FROM
        KBR_TREASURY_COMPANY KTC
    WHERE
        KTC.company_id = KBN.company_id
            ) AS company_name,
    company_id,
    trx_id,
    trx_number,
    instrument_type,
    transaction_action,
    NOTIFICATION_ID,
    KBN.creation_date
FROM
    KBR_APPROVAL_NOTIFICATIONS KBN,
    KBR_LOAN_DTL KLD
WHERE
    KBN.USER_ID = 502
    AND transaction_action = 'INITIAL_CREATION'
    AND current_approver = 'Y'
    AND instrument_type in ('RTM_REPAYMENT', 'REPAYMENT', 'RETAIL_ADV_REPAYMENT')
    AND KLD.transaction_id = trx_id
UNION ALL
SELECT
    (
    SELECT
        CONCAT_WS(':', bank_code, bank_name) AS THIRD_PARTY_NAME
    FROM
        KBR_THIRD_PARTY
    WHERE
        THIRD_PARTY_ID = KFD.THIRD_PARTY_ID
            ) AS THIRD_PARTY_NAME,
    NULL lien,
    classification,
    SETTLEMENT_START_DATE AS start_date,
    SETTLEMENT_MATURITY_DATE AS end_date,
    (
    SELECT
        CONCAT_WS(':', bank_name, account_number)
    FROM
        KBR_BANK_MASTER kbr
    WHERE
        kbr.bank_account_id = KFD.FUNDING_BANK_ACCOUNT ) AS FUNDING_BANK_ACCOUNT,
    CURRENCY,
    par_value_of_the_bond AS amount,
    COUPON_FREQUENCY AS INTEREST_FREQUENCY,
    coupon_rate AS INTEREST_RATE,
    NULL AS BENCHMARK_RATE,
    NULL PURPOSE,
    geography,
    (
    SELECT
        company_name
    FROM
        KBR_TREASURY_COMPANY KTC
    WHERE
        KTC.company_id = KBN.company_id ) AS company_name,
    KFD.company_id,
    trx_id,
    trx_number,
    instrument_type,
    transaction_action,
    NOTIFICATION_ID,
    KBN.creation_date
FROM
    KBR_APPROVAL_NOTIFICATIONS KBN,
    KBR_BOND_DTL KFD
WHERE
    KBN.USER_ID = 502
    AND transaction_action = 'INITIAL_CREATION'
    AND current_approver = 'Y'
    AND instrument_type = 'BN'
    AND BOND_NUMBER = trx_number
UNION ALL
SELECT
    (
    SELECT
        CONCAT_WS(':', bank_code, bank_name) AS THIRD_PARTY_NAME
    FROM
        KBR_THIRD_PARTY
    WHERE
        THIRD_PARTY_ID = KFD.THIRD_PARTY_ID
            ) AS THIRD_PARTY_NAME,
    NULL lien,
    classification,
    PURCHASE_DATE AS start_date,
    NULL AS end_date,
    (
    SELECT
        CONCAT_WS(':', bank_name, account_number)
    FROM
        KBR_BANK_MASTER kbr
    WHERE
        kbr.bank_account_id = KFD.BANK_ACCOUNT_ID ) AS FUNDING_BANK_ACCOUNT,
    CURRENCY,
    amount,
    NULL INTEREST_FREQUENCY,
    0 INTEREST_RATE,
    NULL AS BENCHMARK_RATE,
    NULL PURPOSE,
    geography,
    (
    SELECT
        company_name
    FROM
        KBR_TREASURY_COMPANY KTC
    WHERE
        KTC.company_id = KBN.company_id
            ) AS company_name,
    KFD.company_id,
    KBN.trx_id,
    trx_number,
    instrument_type,
    transaction_action,
    NOTIFICATION_ID,
    KBN.creation_date
FROM
    KBR_APPROVAL_NOTIFICATIONS KBN,
    KBR_EQUITY_BUY KFD
WHERE
    KBN.USER_ID = 502
    AND transaction_action = 'INITIAL_CREATION'
    AND current_approver = 'Y'
    AND FOLIO_NUMBER = trx_number
    AND instrument_type = 'EQUITY_BUY'
UNION ALL
SELECT
    (
    SELECT
        CONCAT_WS(':', bank_code, bank_name) AS THIRD_PARTY_NAME
    FROM
        KBR_THIRD_PARTY
    WHERE
        THIRD_PARTY_ID = KFD.THIRD_PARTY_ID
            ) AS THIRD_PARTY_NAME,
    NULL lien,
    (
    SELECT
        LEVEL
    FROM
        KBR_INST_MASTER
    WHERE
        inst_id = KFD.inst_id ) AS classification,
    SALE_DATE AS start_date,
    NULL AS end_date,
    (
    SELECT
        CONCAT_WS(':', bank_name, account_number)
    FROM
        KBR_BANK_MASTER kbr
    WHERE
        kbr.bank_account_id = KFD.BANK_ACCOUNT_ID ) AS FUNDING_BANK_ACCOUNT,
    (
    SELECT
        currency_code
    FROM
        KBR_INST_MASTER
    WHERE
        inst_id = KFD.inst_id ) AS CURRENCY,
    SALE_AMOUNT AS amount,
    NULL INTEREST_FREQUENCY,
    0 INTEREST_RATE,
    NULL AS BENCHMARK_RATE,
    NULL PURPOSE,
    (
    SELECT
        geography
    FROM
        KBR_INST_MASTER
    WHERE
        inst_id = KFD.inst_id ) AS geography,
    (
    SELECT
        company_name
    FROM
        KBR_TREASURY_COMPANY KTC
    WHERE
        KTC.company_id = KBN.company_id ) AS company_name,
    KFD.company_id,
    KBN.trx_id,
    trx_number,
    instrument_type,
    transaction_action,
    NOTIFICATION_ID,
    KBN.creation_date
FROM
    KBR_APPROVAL_NOTIFICATIONS KBN,
    KBR_EQUITY_SALE KFD
WHERE
    KBN.USER_ID = 502
    AND transaction_action = 'INITIAL_CREATION'
    AND current_approver = 'Y'
    AND sale_trx_id = trx_id
    AND instrument_type = 'EQUITY_SALE'
UNION ALL
SELECT
    (
    SELECT
        CONCAT_WS(':', bank_code, bank_name) AS THIRD_PARTY_NAME
    FROM
        KBR_THIRD_PARTY
    WHERE
        THIRD_PARTY_ID = KFD.THIRD_PARTY_ID
            ) AS THIRD_PARTY_NAME,
    NULL lien,
    (
    SELECT
        LEVEL
    FROM
        KBR_INST_MASTER
    WHERE
        inst_id = KFD.inst_id ) AS classification,
    DIV_RCVD_DATE AS start_date,
    NULL AS end_date,
    (
    SELECT
        CONCAT_WS(':', bank_name, account_number)
    FROM
        KBR_BANK_MASTER kbr
    WHERE
        kbr.bank_account_id = KFD.BANK_ACCOUNT_ID ) AS FUNDING_BANK_ACCOUNT,
    (
    SELECT
        currency_code
    FROM
        KBR_INST_MASTER
    WHERE
        inst_id = KFD.inst_id ) AS CURRENCY,
    DIV_AMOUNT_RCVD AS amount,
    NULL INTEREST_FREQUENCY,
    0 INTEREST_RATE,
    NULL AS BENCHMARK_RATE,
    NULL PURPOSE,
    (
    SELECT
        geography
    FROM
        KBR_INST_MASTER
    WHERE
        inst_id = KFD.inst_id ) AS geography,
    (
    SELECT
        company_name
    FROM
        KBR_TREASURY_COMPANY KTC
    WHERE
        KTC.company_id = KBN.company_id ) AS company_name,
    KFD.company_id,
    KBN.trx_id,
    trx_number,
    instrument_type,
    transaction_action,
    NOTIFICATION_ID,
    KBN.creation_date
FROM
    KBR_APPROVAL_NOTIFICATIONS KBN,
    KBR_EQUITY_DIVIDENDS KFD
WHERE
    KBN.USER_ID = 502
    AND transaction_action = 'INITIAL_CREATION'
    AND current_approver = 'Y'
    AND div_trx_id = trx_id
    AND instrument_type = 'EQUITY_DIVIDEND'
UNION ALL
SELECT
    (
    SELECT
        CONCAT_WS(':', bank_code, bank_name) AS THIRD_PARTY_NAME
    FROM
        KBR_THIRD_PARTY
    WHERE
        THIRD_PARTY_ID = KFD.THIRD_PARTY_NAME
            ) AS THIRD_PARTY_NAME,
    NULL lien,
    (
    SELECT
        LEVEL
    FROM
        KBR_INST_MASTER
    WHERE
        inst_code = KFD.instrument_code
        and company_id = KFD.COMPANY_NAME ) AS classification,
    PURCHASE_DATE AS start_date,
    NULL AS end_date,
    FUNDING_BANK_ACCOUNT,
    CURRENCY,
    PORTFOLIO_PURCHASE_VALUE AS amount,
    NULL INTEREST_FREQUENCY,
    0 INTEREST_RATE,
    NULL AS BENCHMARK_RATE,
    NULL PURPOSE,
    geography,
    company_name,
    (
    SELECT
        company_id
    FROM
        KBR_TREASURY_COMPANY
    WHERE
        company_name = KFD.company_name ) AS company_id,
    KBN.trx_id,
    trx_number,
    instrument_type,
    transaction_action,
    NOTIFICATION_ID,
    KBN.creation_date
FROM
    KBR_APPROVAL_NOTIFICATIONS KBN,
    KBR_EQUITY_PORTFOLIO KFD
WHERE
    KBN.USER_ID = 502
    AND transaction_action = 'INITIAL_CREATION'
    AND current_approver = 'Y'
    AND folio_number = trx_number
    AND INSTRUMENT_TYPE = 'PORT_EQUITY_PURCHASE'
UNION ALL
SELECT
    (
    SELECT
        CONCAT_WS(':', bank_code, bank_name) AS THIRD_PARTY_NAME
    FROM
        KBR_THIRD_PARTY
    WHERE
        THIRD_PARTY_ID = KFD.THIRD_PARTY_NAME
            ) AS THIRD_PARTY_NAME,
    NULL lien,
    (
    SELECT
        LEVEL
    FROM
        KBR_INST_MASTER
    WHERE
        inst_code = KFD.instrument_code
        and company_id = KFD.COMPANY_NAME ) AS classification,
    SALE_DATE AS start_date,
    NULL AS end_date,
    FUNDING_BANK_ACCOUNT,
    CURRENCY,
    PORTFOLIO_SALE_VALUE AS amount,
    NULL INTEREST_FREQUENCY,
    0 INTEREST_RATE,
    NULL AS BENCHMARK_RATE,
    NULL PURPOSE,
    geography,
    company_name,
    (
    SELECT
        company_id
    FROM
        KBR_TREASURY_COMPANY
    WHERE
        company_name = KFD.company_name ) AS company_id,
    KBN.trx_id,
    trx_number,
    instrument_type,
    transaction_action,
    NOTIFICATION_ID,
    KBN.creation_date
FROM
    KBR_APPROVAL_NOTIFICATIONS KBN,
    KBR_EQUITY_PORTFOLIO_SALE KFD
WHERE
    KBN.USER_ID = 502
    AND transaction_action = 'INITIAL_CREATION'
    AND current_approver = 'Y'
    AND folio_number = trx_number
    AND instrument_type = 'PORT_EQUITY_SALE'
UNION ALL
SELECT
    (
    SELECT
        CONCAT_WS(':', bank_code, bank_name) AS THIRD_PARTY_NAME
    FROM
        KBR_THIRD_PARTY
    WHERE
        THIRD_PARTY_ID = KFD.THIRD_PARTY_NAME
            ) AS THIRD_PARTY_NAME,
    NULL lien,
    (
    SELECT
        LEVEL
    FROM
        KBR_INST_MASTER
    WHERE
        inst_code = KFD.instrument_code
        and company_id = KFD.company_name ) AS classification,
    DIVIDEND_DATE AS start_date,
    NULL AS end_date,
    RECEIVING_BANK_ACCOUNT AS FUNDING_BANK_ACCOUNT,
    CURRENCY,
    DIVIDEND_AMOUNT AS amount,
    NULL INTEREST_FREQUENCY,
    0 INTEREST_RATE,
    NULL AS BENCHMARK_RATE,
    NULL PURPOSE,
    geography,
    company_name,
    (
    SELECT
        company_id
    FROM
        KBR_TREASURY_COMPANY
    WHERE
        company_name = KFD.company_name
            ) AS company_id,
    KBN.trx_id,
    trx_number,
    instrument_type,
    transaction_action,
    NOTIFICATION_ID,
    KBN.creation_date
FROM
    KBR_APPROVAL_NOTIFICATIONS KBN,
    KBR_EQUITY_PORTFOLIO_DIVIDEND KFD
WHERE
    KBN.USER_ID = 502
    AND transaction_action = 'INITIAL_CREATION'
    AND current_approver = 'Y'
    AND folio_number = trx_number
    AND instrument_type = 'PORT_EQUITY_DIVIDEND'
UNION ALL
SELECT
    NULL AS THIRD_PARTY_NAME,
    NULL lien,
    NULL classification,
    sale_date AS start_date,
    NULL AS end_date,
    (
    SELECT
        CONCAT_WS(':', bank_name, account_number)
    FROM
        KBR_BANK_MASTER kbr
    WHERE
        kbr.bank_account_id = KFD.RECEIVING_BANK_ACCOUNT ) AS FUNDING_BANK_ACCOUNT,
    KFD.CURRENCY,
    sale_price AS amount,
    NULL AS INTEREST_FREQUENCY,
    NULL AS INTEREST_RATE,
    NULL AS BENCHMARK_RATE,
    NULL PURPOSE,
    NULL geography,
    (
    SELECT
        company_name
    FROM
        KBR_TREASURY_COMPANY KTC
    WHERE
        KTC.company_id = KBN.company_id ) AS company_name,
    KBD.company_id,
    trx_id,
    trx_number,
    instrument_type,
    transaction_action,
    NOTIFICATION_ID,
    KBN.creation_date
FROM
    KBR_APPROVAL_NOTIFICATIONS KBN,
    KBR_BOND_RECORD_SALE KFD,
    KBR_BOND_DTL KBD
WHERE
    KBN.USER_ID = 502
    AND transaction_action = 'INITIAL_CREATION'
    AND current_approver = 'Y'
    AND instrument_type = 'BOND_SALE'
    AND KFD.bond_number = trx_number
    AND KFD.bond_number = KBD.bond_number
    AND KFD.approval_status = 'Pending'
UNION ALL
SELECT
    (
    SELECT
        CONCAT_WS(':', bank_code, bank_name) AS THIRD_PARTY_NAME
    FROM
        KBR_THIRD_PARTY
    WHERE
        THIRD_PARTY_ID = KFD.THIRD_PARTY ) AS THIRD_PARTY_NAME,
    NULL lien,
    NULL classification,
    CP_START_DATE AS start_date,
    CP_END_DATE AS end_date,
    (
    SELECT
        CONCAT_WS(':', bank_name, account_number)
    FROM
        KBR_BANK_MASTER kbr
    WHERE
        kbr.bank_account_id = KFD.FUNDING_BANK_ACCOUNT 
                    ) AS FUNDING_BANK_ACCOUNT,
    CP_TRX_CURRENCY,
    TOTAL_FACE_VALUE AS amount,
    NULL INTEREST_FREQUENCY,
    INTEREST_RATE,
    NULL AS BENCHMARK_RATE,
    NULL PURPOSE,
    NULL geography,
    (
    SELECT
        company_name
    FROM
        KBR_TREASURY_COMPANY KTC
    WHERE
        KTC.company_id = KBN.company_id 
                    ) AS company_name,
    KFD.company_id,
    trx_id,
    trx_number,
    instrument_type,
    transaction_action,
    NOTIFICATION_ID,
    KBN.creation_date
FROM
    KBR_APPROVAL_NOTIFICATIONS KBN,
    KBR_CP_DTL KFD
WHERE
    KBN.USER_ID = 502
    AND transaction_action = 'INITIAL_CREATION'
    AND current_approver = 'Y'
    AND instrument_type = 'COMMERCIAL PAPER'
    AND loan_NUMBER = trx_number
union all
SELECT
    (
    SELECT
        CONCAT_WS(':', bank_code, bank_name) AS THIRD_PARTY_NAME
    FROM
        KBR_THIRD_PARTY
    WHERE
        THIRD_PARTY_ID = KFD.SUPPLIER_NAME  
                                ) AS THIRD_PARTY_NAME,
    NULL lien,
    NULL classification,
    PO_DATE AS start_date,
    null AS end_date,
    null AS FUNDING_BANK_ACCOUNT,
    CURRENCY,
    (
    select
        sum(line_total_tax)
    from
        KBR_PURCHASE_ORDER_HISTORY_DTL
    where
        po_id = trx_id) AS amount,
    NULL INTEREST_FREQUENCY,
    null INTEREST_RATE,
    NULL AS BENCHMARK_RATE,
    NULL PURPOSE,
    NULL geography,
    (
    SELECT
        company_name
    FROM
        KBR_TREASURY_COMPANY KTC
    WHERE
        KTC.company_id = KBN.company_id  
                                ) AS company_name,
    KFD.company_id,
    trx_id,
    trx_number,
    instrument_type,
    transaction_action,
    NOTIFICATION_ID,
    KBN.creation_date
FROM
    KBR_APPROVAL_NOTIFICATIONS KBN,
    KBR_PURCHASE_ORDER_DTL KFD
WHERE
    KBN.USER_ID = 502
    AND transaction_action = 'INITIAL_CREATION'
    AND current_approver = 'Y'
    AND instrument_type = 'Purchase Order'
    AND PO_NUMBER = trx_number
    and po_id = trx_id
union all
SELECT
    (
    SELECT
        CONCAT_WS(':', bank_code, bank_name) AS THIRD_PARTY_NAME
    FROM
        KBR_THIRD_PARTY
    WHERE
        THIRD_PARTY_ID = KFD.SUPPLIER_NAME   
                                            ) AS THIRD_PARTY_NAME,
    NULL lien,
    NULL classification,
    INVOICE_DATE AS start_date,
    null AS end_date,
    (
    SELECT
        CONCAT_WS(':', bank_name, account_number)
    FROM
        KBR_BANK_MASTER kbr
    WHERE
        kbr.bank_account_id = KFD.bank_account) AS FUNDING_BANK_ACCOUNT,
    CURRENCY,
    Invoice_Amount AS amount,
    NULL INTEREST_FREQUENCY,
    null INTEREST_RATE,
    NULL AS BENCHMARK_RATE,
    NULL PURPOSE,
    NULL geography,
    (
    SELECT
        company_name
    FROM
        KBR_TREASURY_COMPANY KTC
    WHERE
        KTC.company_id = KBN.company_id   
                                            ) AS company_name,
    KFD.company_id,
    trx_id,
    trx_number,
    instrument_type,
    transaction_action,
    NOTIFICATION_ID,
    KBN.creation_date
FROM
    KBR_APPROVAL_NOTIFICATIONS KBN,
    KBR_FINANCE_SUPPLIER_INVOICE_DTL KFD
WHERE
    KBN.USER_ID = 502
    AND transaction_action = 'INITIAL_CREATION'
    AND current_approver = 'Y'
    AND instrument_type = 'Supplier Invoice'
    AND INVOICE_NUMBER = trx_number
union all
SELECT
    (
    SELECT
        CONCAT_WS(':', bank_code, bank_name) AS THIRD_PARTY_NAME
    FROM
        KBR_THIRD_PARTY
    WHERE
        THIRD_PARTY_ID = KFD.THIRD_PARTY_NAME   
                                            ) AS THIRD_PARTY_NAME,
    NULL lien,
    NULL classification,
    ACCOUNTING_DATE AS start_date,
    null AS end_date,
    null AS FUNDING_BANK_ACCOUNT,
    CURRENCY CURRENCY,
    (
    SELECT
        IFNULL(SUM(accounted_dr), 0)
    FROM
        KBR_FINANCE_JOURNAL_LINE_DTL
    WHERE
        jou_id = KFD.jou_id
        AND accounted_dr IS NOT NULL
        AND accounted_cr = '0') AS amount,
    NULL INTEREST_FREQUENCY,
    null INTEREST_RATE,
    NULL AS BENCHMARK_RATE,
    NULL PURPOSE,
    NULL geography,
    (
    SELECT
        company_name
    FROM
        KBR_TREASURY_COMPANY KTC
    WHERE
        KTC.company_id = KBN.company_id   
                                            ) AS company_name,
    KFD.company_id,
    trx_id,
    trx_number,
    instrument_type,
    transaction_action,
    NOTIFICATION_ID,
    KBN.creation_date
FROM
    KBR_APPROVAL_NOTIFICATIONS KBN,
    KBR_FINANCE_JOURNAL_DTL KFD
WHERE
    KBN.USER_ID = 502
    AND transaction_action = 'INITIAL_CREATION'
    AND current_approver = 'Y'
    AND instrument_type = 'Journal'
    AND Journal_NUMBER = trx_number
    and jou_id = trx_id
union all
SELECT
    (
    SELECT
        CONCAT_WS(':', bank_code, bank_name) AS THIRD_PARTY_NAME
    FROM
        KBR_THIRD_PARTY
    WHERE
        THIRD_PARTY_ID = KFD.THIRD_PARTY_ID) AS THIRD_PARTY_NAME,
    NULL lien,
    NULL classification,
    due_date AS start_date,
    NULL end_date,
    (
    SELECT
        CONCAT_WS(':', bank_name, account_number)
    FROM
        KBR_BANK_MASTER kbr
    WHERE
        kbr.bank_account_id = KFD.INTERNAL_BANK_ACCOUNT_ID) AS FUNDING_BANK_ACCOUNT,
    CURRENCY_CODE,
    SUM(AMOUNT) AS amount,
    NULL INTEREST_FREQUENCY,
    NULL INTEREST_RATE,
    NULL AS BENCHMARK_RATE,
    NULL PURPOSE,
    NULL geography,
    (
    SELECT
        company_name
    FROM
        KBR_TREASURY_COMPANY KTC
    WHERE
        KTC.company_id = KBN.company_id) AS company_name,
    company_id,
    KBN.trx_id,
    KBN.trx_number,
    instrument_type,
    transaction_action,
    NOTIFICATION_ID,
    KBN.creation_date
FROM
    KBR_APPROVAL_NOTIFICATIONS KBN,
    KBR_SETTLEMENTS KFD
WHERE
    KBN.USER_ID = 502
    AND transaction_action = 'INITIAL_CREATION'
    AND current_approver = 'Y'
    AND instrument_type = 'Settlements'
    AND SETTLE_BATCH_ID = KBN.trx_id
group by
    SETTLE_BATCH_ID
union all
SELECT
    (
    SELECT
        CONCAT_WS(':', bank_code, bank_name) AS THIRD_PARTY_NAME
    FROM
        KBR_THIRD_PARTY
    WHERE
        THIRD_PARTY_ID = KFD.THIRD_PARTY_NAME) AS THIRD_PARTY_NAME,
    NULL lien,
    NULL classification,
    transaction_date AS start_date,
    NULL end_date,
    (
    SELECT
        CONCAT_WS(':', bank_name, account_number)
    FROM
        KBR_BANK_MASTER kbr
    WHERE
        kbr.bank_account_id = KFD.BANK_ACCOUNT) AS FUNDING_BANK_ACCOUNT,
    CURRENCY,
    TRANSACTION_AMOUNT AS amount,
    NULL INTEREST_FREQUENCY,
    NULL INTEREST_RATE,
    NULL AS BENCHMARK_RATE,
    NULL PURPOSE,
    NULL geography,
    (
    SELECT
        company_name
    FROM
        KBR_TREASURY_COMPANY KTC
    WHERE
        KTC.company_id = KBN.company_id) AS company_name,
    KBN.company_id,
    KBN.trx_id,
    KBN.trx_number,
    instrument_type,
    transaction_action,
    NOTIFICATION_ID,
    KBN.creation_date
FROM
    KBR_APPROVAL_NOTIFICATIONS KBN,
    KBR_MISC_TRX_DTL KFD
WHERE
    KBN.USER_ID = 502
    AND transaction_action = 'INITIAL_CREATION'
    AND current_approver = 'Y'
    AND instrument_type = 'Misc_Trx'
    AND KFD.trx_number = KBN.trx_number
    and mi_id = KBN.trx_id
union all
SELECT
    (
    SELECT
        CONCAT_WS(':', bank_code, bank_name) AS THIRD_PARTY_NAME
    FROM
        KBR_THIRD_PARTY
    WHERE
        THIRD_PARTY_ID = KFD.SUPPLIER_NAME) AS THIRD_PARTY_NAME,
    NULL lien,
    NULL classification,
    invoice_date AS start_date,
    NULL end_date,
    (
    SELECT
        CONCAT_WS(':', bank_name, account_number)
    FROM
        KBR_BANK_MASTER kbr
    WHERE
        kbr.bank_account_id = KFD.BANK_ACCOUNT) AS FUNDING_BANK_ACCOUNT,
    CURRENCY,
    INVOICE_LINE_TOTAL_TAX AS amount,
    NULL INTEREST_FREQUENCY,
    NULL INTEREST_RATE,
    NULL BENCHMARK_RATE,
    NULL PURPOSE,
    NULL geography,
    (
    SELECT
        company_name
    FROM
        KBR_TREASURY_COMPANY KTC
    WHERE
        KTC.company_id = KBN.company_id) AS company_name,
    company_id,
    trx_id,
    trx_number,
    instrument_type,
    transaction_action,
    NOTIFICATION_ID,
    KBN.creation_date
FROM
    KBR_APPROVAL_NOTIFICATIONS KBN,
    KBR_AP_INVOICE_LINE_DTL KFD
WHERE
    KBN.USER_ID = 502
    AND transaction_action = 'INITIAL_CREATION'
    AND current_approver = 'Y'
    AND instrument_type = 'AP_INV'
    AND invoice_number = trx_number
    and ap_id = trx_id
union all
SELECT
    null THIRD_PARTY_NAME,
    NULL lien,
    NULL classification,
    reval_date AS start_date,
    NULL end_date,
    null FUNDING_BANK_ACCOUNT,
    CURRENCY,
    null amount,
    NULL INTEREST_FREQUENCY,
    NULL INTEREST_RATE,
    NULL AS BENCHMARK_RATE,
    NULL PURPOSE,
    NULL geography,
    (
    SELECT
        company_name
    FROM
        KBR_TREASURY_COMPANY KTC
    WHERE
        KTC.company_id = KBN.company_id) AS company_name,
    KBN.company_id,
    KBN.trx_id,
    KBN.trx_number,
    instrument_type,
    transaction_action,
    NOTIFICATION_ID,
    KBN.creation_date
FROM
    KBR_APPROVAL_NOTIFICATIONS KBN,
    KBR_REVAL_TEMP KFD
WHERE
    KBN.USER_ID = 502
    AND transaction_action = 'INITIAL_CREATION'
    AND current_approver = 'Y'
    AND instrument_type = 'REVALUATION'
    AND REVAL_HEADER_BATCH_NO = KBN.trx_number
    AND session_id = KBN.trx_id
group by
    REVAL_HEADER_BATCH_NO
union all
SELECT
    (
    SELECT
        CONCAT_WS(':', bank_code, bank_name) AS THIRD_PARTY_NAME
    FROM
        KBR_THIRD_PARTY
    WHERE
        THIRD_PARTY_ID = third_party) THIRD_PARTY_NAME,
    NULL lien,
    NULL classification,
    null AS start_date,
    NULL end_date,
    null FUNDING_BANK_ACCOUNT,
    CURRENCY,
    proposed_investment amount,
    NULL INTEREST_FREQUENCY,
    NULL INTEREST_RATE,
    NULL AS BENCHMARK_RATE,
    NULL PURPOSE,
    NULL geography,
    (
    SELECT
        company_name
    FROM
        KBR_TREASURY_COMPANY KTC
    WHERE
        KTC.company_id = KBN.company_id) AS company_name,
    KBN.company_id,
    KBN.trx_id,
    KBN.trx_number,
    instrument_type,
    transaction_action,
    NOTIFICATION_ID,
    KBN.creation_date
FROM
    KBR_APPROVAL_NOTIFICATIONS KBN,
    KBR_FEASIBILITY_HDR KFD
WHERE
    KBN.USER_ID = 502
    AND transaction_action = 'INITIAL_CREATION'
    AND current_approver = 'Y'
    AND instrument_type = 'FEASIBILITY'
    AND req_id = KBN.trx_id
    AND inst_code = KBN.trx_number
union all
SELECT
    (
    SELECT
        CONCAT_WS(':', bank_code, bank_name) AS THIRD_PARTY_NAME
    FROM
        KBR_THIRD_PARTY
    WHERE
        THIRD_PARTY_ID = KFD.third_party_id) THIRD_PARTY_NAME,
    NULL lien,
    NULL classification,
    start_date,
    MATURITY_DATE end_date,
    null FUNDING_BANK_ACCOUNT,
    null CURRENCY,
    null amount,
    NULL INTEREST_FREQUENCY,
    NULL INTEREST_RATE,
    NULL AS BENCHMARK_RATE,
    NULL PURPOSE,
    NULL geography,
    (
    SELECT
        company_name
    FROM
        KBR_TREASURY_COMPANY KTC
    WHERE
        KTC.company_id = KBN.company_id) AS company_name,
    KBN.company_id,
    KBN.trx_id,
    KBN.trx_number,
    instrument_type,
    transaction_action,
    NOTIFICATION_ID,
    KBN.creation_date
FROM
    KBR_APPROVAL_NOTIFICATIONS KBN,
    KBR_COMMODITY_SWAPS_DTL KFD
WHERE
    KBN.USER_ID = 502
    AND transaction_action = 'INITIAL_CREATION'
    AND current_approver = 'Y'
    AND instrument_type = 'COMMODITY_SWAPS'
    AND transaction_id = KBN.trx_id
    AND swap_number = KBN.trx_number
union all
SELECT
    (
    SELECT
        CONCAT_WS(':', bank_code, bank_name) AS THIRD_PARTY_NAME
    FROM
        KBR_THIRD_PARTY
    WHERE
        THIRD_PARTY_ID = KFD.third_party_id) THIRD_PARTY_NAME,
    NULL lien,
    NULL classification,
    PURCHASE_DATE,
    EXPIRATION_DATE end_date,
    BANK_ACCOUNT_ID FUNDING_BANK_ACCOUNT,
    CURRENCY,
    margin_amount amount,
    NULL INTEREST_FREQUENCY,
    NULL INTEREST_RATE,
    NULL AS BENCHMARK_RATE,
    NULL PURPOSE,
    NULL geography,
    (
    SELECT
        company_name
    FROM
        KBR_TREASURY_COMPANY KTC
    WHERE
        KTC.company_id = KBN.company_id) AS company_name,
    KBN.company_id,
    KBN.trx_id,
    KBN.trx_number,
    instrument_type,
    transaction_action,
    NOTIFICATION_ID,
    KBN.creation_date
FROM
    KBR_APPROVAL_NOTIFICATIONS KBN,
    KBR_CURRENCY_FUTURES KFD
WHERE
    KBN.USER_ID = 502
    AND transaction_action = 'INITIAL_CREATION'
    AND current_approver = 'Y'
    AND instrument_type = 'FUTURES'
    AND s_no = KBN.trx_id
    AND FOLIO_NUMBER = KBN.trx_number
union all
SELECT
    (
    SELECT
        CONCAT_WS(':', bank_code, bank_name) AS THIRD_PARTY_NAME
    FROM
        KBR_THIRD_PARTY
    WHERE
        THIRD_PARTY_ID = KFD.BANK_NAME) AS THIRD_PARTY_NAME,
    null lien,
    null classification,
    LC_OPENING_DATE AS start_date,
    LC_EXPIRY_DATE AS end_date,
    (
    SELECT
        CONCAT_WS(':', bank_name, account_number)
    FROM
        KBR_BANK_MASTER kbr
    WHERE
        kbr.bank_account_id = KFD.BANK_ACCOUNT_ID) AS FUNDING_BANK_ACCOUNT,
    LC_CURRENCY,
    lc_value AS amount,
    null INTEREST_FREQUENCY,
    INTEREST_RATE,
    NULL AS BENCHMARK_RATE,
    NULL PURPOSE,
    NULL geography,
    (
    SELECT
        company_name
    FROM
        KBR_TREASURY_COMPANY KTC
    WHERE
        KTC.company_id = KBN.company_id) AS company_name,
    company_id,
    trx_id,
    trx_number,
    instrument_type,
    transaction_action,
    NOTIFICATION_ID,
    KBN.creation_date
FROM
    KBR_APPROVAL_NOTIFICATIONS KBN,
    KBR_LC_HEADER KFD
WHERE
    KBN.USER_ID = 502
    AND transaction_action = 'INITIAL_CREATION'
    AND current_approver = 'Y'
    AND instrument_type = 'LC'
    AND LC_NUMBER = trx_number
union all
SELECT
    (
    SELECT
        CONCAT_WS(':', bank_code, bank_name) AS THIRD_PARTY_NAME
    FROM
        KBR_THIRD_PARTY
    WHERE
        THIRD_PARTY_ID = KFD.THIRD_PARTY_BANK_ID) AS THIRD_PARTY_NAME,
    NULL lien,
    NULL classification,
    STL_START_DATE AS start_date,
    STL_DUE_DATE AS end_date,
    (
    SELECT
        CONCAT_WS(':', bank_name, account_number)
    FROM
        KBR_BANK_MASTER kbr
    WHERE
        kbr.bank_account_id = KFD.RECEIVING_BANK_ACCOUNT_ID) AS FUNDING_BANK_ACCOUNT,
    STL_CURRENCY,
    STL_AMOUNT AS amount,
    INTEREST_FREQUENCY,
    INTEREST_RATE,
    BENCHMARK_RATE,
    NULL PURPOSE,
    NULL geography,
    (
    SELECT
        company_name
    FROM
        KBR_TREASURY_COMPANY KTC
    WHERE
        KTC.company_id = KBN.company_id) AS company_name,
    company_id,
    trx_id,
    trx_number,
    instrument_type,
    transaction_action,
    NOTIFICATION_ID,
    KBN.creation_date
FROM
    KBR_APPROVAL_NOTIFICATIONS KBN,
    KBR_STL_HEADER KFD
WHERE
    KBN.USER_ID = 502
    AND transaction_action = 'INITIAL_CREATION'
    AND current_approver = 'Y'
    AND instrument_type in( 'STL', 'STM')
    AND STL_REFERENCE_NUMBER = trx_number
union all
SELECT
    (
    SELECT
        CONCAT_WS(':', bank_code, bank_name) AS THIRD_PARTY_NAME
    FROM
        KBR_THIRD_PARTY
    WHERE
        THIRD_PARTY_ID = KFD.THIRD_PARTY_ID) AS THIRD_PARTY_NAME,
    NULL lien,
    NULL classification,
    BG_START_DATE AS start_date,
    BG_EXPIRY_DATE AS end_date,
    (
    SELECT
        CONCAT_WS(':', bank_name, account_number)
    FROM
        KBR_BANK_MASTER kbr
    WHERE
        kbr.bank_account_id = KFD.issuing_bank) AS FUNDING_BANK_ACCOUNT,
    BG_CURRENCY,
    BG_amount,
    NULL INTEREST_FREQUENCY,
    NULL INTEREST_RATE,
    NULL AS BENCHMARK_RATE,
    NULL PURPOSE,
    NULL geography,
    (
    SELECT
        company_name
    FROM
        KBR_TREASURY_COMPANY KTC
    WHERE
        KTC.company_id = KBN.company_id) AS company_name,
    company_id,
    trx_id,
    trx_number,
    instrument_type,
    transaction_action,
    NOTIFICATION_ID,
    KBN.creation_date
FROM
    KBR_APPROVAL_NOTIFICATIONS KBN,
    KBR_BG KFD
WHERE
    KBN.USER_ID = 502
    AND transaction_action = 'INITIAL_CREATION'
    AND current_approver = 'Y'
    AND instrument_type = 'BG'
    AND BG_REFERENCE = trx_number
union all
select
    (
    SELECT
        CONCAT_WS(':', bank_code, bank_name) AS THIRD_PARTY_NAME
    FROM
        KBR_THIRD_PARTY
    WHERE
        THIRD_PARTY_ID = KFD.BANK_NAME) AS THIRD_PARTY_NAME,
    null lien,
    null classification,
    ACCEPT_DATE AS start_date,
    null AS end_date,
    (
    SELECT
        CONCAT_WS(':', bank_name, account_number)
    FROM
        KBR_BANK_MASTER kbr
    WHERE
        kbr.bank_account_id = KFD.BANK_ACCOUNT_ID) AS FUNDING_BANK_ACCOUNT,
    LC_CURRENCY,
    lc_value AS amount,
    null INTEREST_FREQUENCY,
    INTEREST_RATE,
    NULL AS BENCHMARK_RATE,
    NULL PURPOSE,
    NULL geography,
    (
    SELECT
        company_name
    FROM
        KBR_TREASURY_COMPANY KTC
    WHERE
        KTC.company_id = KBN.company_id) AS company_name,
    company_id,
    trx_id,
    trx_number,
    instrument_type,
    transaction_action,
    NOTIFICATION_ID,
    KBN.creation_date
FROM
    KBR_APPROVAL_NOTIFICATIONS KBN,
    KBR_LC_HEADER KFD
WHERE
    KBN.USER_ID = 502
    AND transaction_action = 'INITIAL_CREATION'
    AND current_approver = 'Y'
    AND instrument_type = 'LC SETTLE'
    AND LC_NUMBER = trx_number
union all
SELECT
    null THIRD_PARTY_NAME,
    NULL lien,
    NULL classification,
    valuation_date AS start_date,
    NULL end_date,
    null FUNDING_BANK_ACCOUNT,
    buy_currency CURRENCY,
    null amount,
    NULL INTEREST_FREQUENCY,
    NULL INTEREST_RATE,
    NULL AS BENCHMARK_RATE,
    NULL PURPOSE,
    NULL geography,
    (
    SELECT
        company_name
    FROM
        KBR_TREASURY_COMPANY KTC
    WHERE
        KTC.company_id = KBN.company_id) AS company_name,
    KBN.company_id,
    KBN.trx_id,
    KBN.trx_number,
    instrument_type,
    transaction_action,
    NOTIFICATION_ID,
    KBN.creation_date
FROM
    KBR_APPROVAL_NOTIFICATIONS KBN,
    KBR_DERIVATIVES_DTL KFD
WHERE
    KBN.USER_ID = 502
    AND transaction_action = 'INITIAL_CREATION'
    AND current_approver = 'Y'
    AND instrument_type = 'DERIVATIVES'
    AND BATCH_ID = KBN.trx_number
group by
    BATCH_ID
union all
SELECT
    NULL THIRD_PARTY_NAME,
    NULL lien,
    NULL classification,
    start_date,
    due_date end_date,
    NULL FUNDING_BANK_ACCOUNT,
    NULL CURRENCY,
    NULL amount,
    NULL INTEREST_FREQUENCY,
    NULL INTEREST_RATE,
    NULL AS BENCHMARK_RATE,
    NULL PURPOSE,
    NULL geography,
    (
    SELECT
        company_name
    FROM
        KBR_TREASURY_COMPANY KTC
    WHERE
        KTC.company_id = KBN.company_id) AS company_name,
    KBN.company_id,
    KBN.trx_id,
    KBN.trx_number,
    instrument_type,
    transaction_action,
    NOTIFICATION_ID,
    KBN.creation_date
FROM
    KBR_APPROVAL_NOTIFICATIONS KBN,
    KBR_FORWARDS_DTL KFD
WHERE
    KBN.USER_ID = 502
    AND transaction_action = 'INITIAL_CREATION'
    AND current_approver = 'Y'
    AND instrument_type = 'FORWARDS'
    AND deal_id = KBN.trx_id
    AND forward_number = KBN.trx_number
union all
SELECT
    (
    SELECT
        CONCAT_WS(':', bank_code, bank_name) AS THIRD_PARTY_NAME
    FROM
        KBR_THIRD_PARTY
    WHERE
        THIRD_PARTY_ID = KFD.third_party_id) THIRD_PARTY_NAME,
    NULL lien,
    NULL classification,
    start_date,
    MATURITY_DATE end_date,
    NULL FUNDING_BANK_ACCOUNT,
    NULL CURRENCY,
    NULL amount,
    NULL INTEREST_FREQUENCY,
    NULL INTEREST_RATE,
    NULL AS BENCHMARK_RATE,
    NULL PURPOSE,
    NULL geography,
    (
    SELECT
        company_name
    FROM
        KBR_TREASURY_COMPANY KTC
    WHERE
        KTC.company_id = KBN.company_id) AS company_name,
    KBN.company_id,
    KBN.trx_id,
    KBN.trx_number,
    instrument_type,
    transaction_action,
    NOTIFICATION_ID,
    KBN.creation_date
FROM
    KBR_APPROVAL_NOTIFICATIONS KBN,
    KBR_IRS_DTL KFD
WHERE
    KBN.USER_ID = 502
    AND transaction_action = 'INITIAL_CREATION'
    AND current_approver = 'Y'
    AND instrument_type = 'INTEREST_RATE_SWAPS'
    AND transaction_id = KBN.trx_id
    AND swap_number = KBN.trx_number
union all
SELECT
    (
    SELECT
        CONCAT_WS(':', bank_code, bank_name) AS THIRD_PARTY_NAME
    FROM
        KBR_THIRD_PARTY
    WHERE
        THIRD_PARTY_ID = KFD.THIRD_PARTY_ID) AS THIRD_PARTY_NAME,
    NULL lien,
    (
    SELECT
        LEVEL
    FROM
        KBR_INST_MASTER
    WHERE
        inst_id = KFD.inst_id) AS classification,
    SPLIT_DATE AS start_date,
    NULL AS end_date,
    NULL FUNDING_BANK_ACCOUNT,
    (
    SELECT
        currency_code
    FROM
        KBR_INST_MASTER
    WHERE
        inst_id = KFD.inst_id) AS CURRENCY,
    NULL AS amount,
    NULL INTEREST_FREQUENCY,
    0 INTEREST_RATE,
    NULL AS BENCHMARK_RATE,
    NULL PURPOSE,
    (
    SELECT
        geography
    FROM
        KBR_INST_MASTER
    WHERE
        inst_id = KFD.inst_id) AS geography,
    (
    SELECT
        company_name
    FROM
        KBR_TREASURY_COMPANY KTC
    WHERE
        KTC.company_id = KBN.company_id) AS company_name,
    KFD.company_id,
    KBN.trx_id,
    trx_number,
    instrument_type,
    transaction_action,
    NOTIFICATION_ID,
    KBN.creation_date
FROM
    KBR_APPROVAL_NOTIFICATIONS KBN,
    KBR_EQUITY_SPLIT KFD
WHERE
    KBN.USER_ID = 502
    AND transaction_action = 'INITIAL_CREATION'
    AND current_approver = 'Y'
    AND s_no = trx_id
    AND instrument_type = 'EQUITY_SPLIT'
union all
SELECT
    (
    SELECT
        CONCAT_WS(':', bank_code, bank_name) AS THIRD_PARTY_NAME
    FROM
        KBR_THIRD_PARTY
    WHERE
        THIRD_PARTY_ID = KFD.BROKERAGE_HOUSE) THIRD_PARTY_NAME,
    NULL lien,
    NULL classification,
    deal_date,
    expiration_DATE end_date,
    FUNDING_BANK_ACCOUNT,
    DEAL_CURRENCY CURRENCY,
    MARGIN_VALUE amount,
    NULL INTEREST_FREQUENCY,
    NULL INTEREST_RATE,
    NULL AS BENCHMARK_RATE,
    NULL PURPOSE,
    NULL geography,
    (
    SELECT
        company_name
    FROM
        KBR_TREASURY_COMPANY KTC
    WHERE
        KTC.company_id = KBN.company_id) AS company_name,
    KBN.company_id,
    KBN.trx_id,
    KBN.trx_number,
    KBN.instrument_type,
    transaction_action,
    NOTIFICATION_ID,
    KBN.creation_date
FROM
    KBR_APPROVAL_NOTIFICATIONS KBN,
    KBR_STOCK_OPTION KFD
WHERE
    KBN.USER_ID = 502
    AND transaction_action = 'INITIAL_CREATION'
    AND current_approver = 'Y'
    AND KBN.instrument_type = 'OPTIONS'
    AND stock_option_id = KBN.trx_id
    AND folio_number = KBN.trx_number)
ORDER BY
creation_date ASC