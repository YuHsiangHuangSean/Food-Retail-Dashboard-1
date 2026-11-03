{{ config(
    description = "All prices should be above 0",
    severity = "error",
    error_if = "> 3000",
    warn_if = "> 0"
) }} 

SELECT
    id AS id,
    price AS price
FROM {{ source('raw', 'prices')}}
WHERE price_is_discounted IS FALSE AND price <= 0