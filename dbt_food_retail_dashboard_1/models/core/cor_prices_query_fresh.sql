SELECT
    id,
    CONCAT(category_fresh, ' (per ', unit, ')') AS product,
    label,
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
    country_code
FROM {{ ref('stg_prices_unify_currency') }}
WHERE product_type = 'CATEGORY'