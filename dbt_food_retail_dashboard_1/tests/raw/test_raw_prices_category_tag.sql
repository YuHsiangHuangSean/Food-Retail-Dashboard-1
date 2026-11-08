SELECT
    id AS id,
    type AS product_type,
    category_tag AS category_tag,
FROM {{ source('raw', 'prices')}}
WHERE type = 'CATEGORY' AND category_tag IS NULL