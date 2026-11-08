# Since the monthly average exchange rate of the current month is not available,
# use the rate of last month instead
WITH prices_prepared AS (
    SELECT
        *,
        # Since BGN was replaced by EUR in 2026, the monthly average rate of 2025-12 is used for 2026 records 
        CASE
            WHEN currency = 'BGN' AND date >= DATE '2026-01-01'
                THEN '2015-12'
            ELSE FORMAT_DATE(
                '%Y-%m',
                CASE
                    WHEN DATE_TRUNC(date, MONTH) = DATE_TRUNC(CURRENT_DATE(), MONTH)
                        THEN DATE_SUB(date, INTERVAL 1 MONTH)
                    ELSE date
                END
            ) 
        END AS month_w_available_ex_rate
    FROM {{ ref('stg_prices_query_EU_EEA') }}
    WHERE currency IN (
        'EUR', 'BGN', 'CZK', 'DKK', 'HUF', 'PLN',
        'RON', 'SEK', 'ISK', 'NOK', 'CHF', 'HRK'
    )
)

SELECT
    prices.id AS id,
    prices.product_type AS product_type,
    prices.product_code AS product_code,
    prices.product_name AS product_name,
    prices.category_fresh AS category_fresh,
    prices.label AS label,
    prices.price AS price,
    prices.discounted AS discounted,
    prices.price_original AS price_original,
    CASE
        WHEN prices.currency = 'EUR'
        THEN 1
        ELSE SAFE_DIVIDE (1, ex_rates.OBS_VALUE)
    END AS exchange_rate,
    CASE
        WHEN prices.currency = 'EUR'
        THEN prices.price
        ELSE SAFE_DIVIDE (prices.price, ex_rates.OBS_VALUE)
    END AS price_eur,
    CASE
        WHEN prices.currency = 'EUR'
        THEN prices.price_original
        ELSE SAFE_DIVIDE (prices.price_original, ex_rates.OBS_VALUE)
    END AS price_original_eur,
    prices.unit AS unit,
    prices.currency AS currency,
    prices.date AS date,
    prices.month_w_available_ex_rate AS month_w_available_ex_rate,
    prices.created_at AS created_at,
    prices.updated_at AS updated_at,
    prices.country_code AS country_code
FROM prices_prepared AS prices
LEFT JOIN {{ ref('exchange_rates') }} AS ex_rates
    ON prices.currency = ex_rates.CURRENCY
    AND prices.month_w_available_ex_rate = ex_rates.TIME_PERIOD