SELECT 
  {{ agg_group_columns() }},
  price_eur,
  price_original_eur,
  updated_at
FROM {{ ref('cor_prices_query_fresh') }}