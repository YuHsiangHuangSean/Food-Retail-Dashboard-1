{{ config(enabled=false) }}
SELECT
    CASE
        WHEN prices.currency = 'EUR'
        THEN 1
        ELSE 1 / ex_rates.OBS_VALUE
    END AS exchange_rate,
    
    # Define what to return
FROM {{ ref('stg_prices_query_EU_EEA')}} AS prices
LEFT JOIN {{ ref('exchange_rates')}} AS ex_rates
    ON prices.currency = ex_rates.CURRENCY AND FORMAT_DATE('%Y-%m', prices.date) = ex_rates.TIME_PERIOD
# Change all currencies ['EUR', 'BGN', 'CZK', 'DKK', 'HUF', 'PLN', 'RON', 'SEK', 'ISK', 'NOK', 'CHF', 'HRK'] to EUR.
# WIP earliest: 2009-04-01