{{ config(
    description = "Units should be either KILOGRAM or UNIT"
) }} 

SELECT
    id AS id,
    type AS product_type,
    price_per AS unit
FROM {{ source('raw', 'prices')}}
WHERE type = 'CATEGORY'
  AND (
      price_per NOT IN ('KILOGRAM', 'UNIT')
      OR price_per IS NULL
  )