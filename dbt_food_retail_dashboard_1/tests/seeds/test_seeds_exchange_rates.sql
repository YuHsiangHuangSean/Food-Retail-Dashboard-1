{{ config(
    description = "The combination of currency and year-month should be unique"
) }} 

SELECT
    CURRENCY,
    TIME_PERIOD,
    COUNT(*)
FROM {{ ref('exchange_rates')}}
GROUP BY CURRENCY, TIME_PERIOD
HAVING COUNT(*) > 1