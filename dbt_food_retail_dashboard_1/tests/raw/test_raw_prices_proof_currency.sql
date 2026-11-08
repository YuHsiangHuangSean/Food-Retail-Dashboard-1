SELECT
    id AS id,
    currency AS currency,
    proof_currency AS proof_currency
FROM {{ source('raw', 'prices')}}
WHERE
    proof_currency IS NOT NULL
    AND proof_currency IS DISTINCT FROM currency
    AND id != 119743
    AND id != 119744 # manually confirm that the currency is correct