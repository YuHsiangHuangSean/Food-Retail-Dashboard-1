SELECT 
    {{ agg_group_columns() }},
    ROUND(price_eur, 2) AS price_eur
FROM {{ ref('cor_prices_packaged_clean') }}