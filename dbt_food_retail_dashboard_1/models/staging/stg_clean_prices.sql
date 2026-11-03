SELECT
    id AS id,
    type AS product_type,
    product_code AS product_code,
    product_name AS product_name,
    category_tag AS category_fresh
    # WIP
FROM {{ source('raw', 'prices')}}