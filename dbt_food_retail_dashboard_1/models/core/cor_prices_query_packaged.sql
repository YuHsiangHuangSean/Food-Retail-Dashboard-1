{{ config(materialized='table') }}

SELECT
    id,
    product_code,
    product_name,
    price,
    discounted,
    price_original,
    exchange_rate,
    price_eur,
    price_original_eur,
    currency,
    date,
    created_at,
    updated_at,
    country_code,
    found_in_product_database,
    quantity_packaged AS quantity,
    quantity_unit_packaged AS quantity_unit,
    categories_packaged AS categories,
    labels_packaged,
    nutriscore_grade,
    greenscore_grade,
    nova_group
FROM {{ ref('stg_prices_unify_currency') }}
WHERE product_type = 'PRODUCT'