# ADP has been replaced by EUR since 1999, yet the currency of some records are wrongfully marked as ADP
SELECT * REPLACE(
    CASE
        WHEN currency = 'ADP'
        THEN 'EUR'
        ELSE currency
    END AS currency
)
FROM {{ ref('stg_prices_clean') }}
WHERE
    country_code IN (
        SELECT Country_code_in_prices
        FROM {{ ref('EU_EEA_Countries') }}
    )
    # XPF is the currency used in French overseas territories, which are not a part of EU/EEA
    AND currency IS DISTINCT FROM 'XPF'