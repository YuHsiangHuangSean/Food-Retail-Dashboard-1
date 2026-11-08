{{ config(
    severity = "error",
    error_if = "> 8000",
    warn_if = "> 0"
) }} 

SELECT
    id AS id,
    price_is_discounted AS price_is_discounted,
    price_without_discount AS price_without_discount
FROM {{ source('raw', 'prices')}}
WHERE
    price_is_discounted IS TRUE
    AND price_without_discount is NULL