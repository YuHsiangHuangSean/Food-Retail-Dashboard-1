SELECT
    id,
    product_name,
    category_fresh AS category,
    label,
    price,
    discounted,
    price_original,
    exchange_rate
    price_eur,
    price_original_eur,
    unit,
    currency,
    date,
    created_at,
    updated_at,
    country_code
FROM {{ ref('stg_prices_unify_currency') }}
WHERE product_type = 'CATEGORY'