{{ config(
    description = "All packaged products should have product codes"
) }} 

SELECT
    id AS id,
    type AS product_type,
    product_code AS product_code
FROM {{ source('raw', 'prices')}}
WHERE type = 'PRODUCT' AND product_code IS NULL