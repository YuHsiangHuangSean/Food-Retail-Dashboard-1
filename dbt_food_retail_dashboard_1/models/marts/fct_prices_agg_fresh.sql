WITH prices AS (
    SELECT
      {{ agg_group_columns() }},
      price_eur,
      price_original_eur,
      updated_at,
      PERCENTILE_CONT(price_eur, 0.5) OVER (
        PARTITION BY
          {{ agg_group_columns() }}            
      ) AS median_price_eur,
      PERCENTILE_CONT(price_original_eur, 0.5) OVER (
        PARTITION BY
          {{ agg_group_columns() }}            
      ) AS median_price_original_eur
    FROM {{ ref('cor_prices_query_fresh') }}
)

SELECT 
  {{ agg_group_columns() }},
  COUNT(*) AS record_count,
  AVG(price_eur) AS avg_price_eur,
  MAX(median_price_eur) AS median_price_eur,
  AVG(price_original_eur) AS avg_price_original_eur,
  MAX(median_price_original_eur) AS median_price_original_eur,
  MAX(updated_at) AS updated_at
FROM prices
GROUP BY
  {{ agg_group_columns() }}
ORDER BY COUNT(*) DESC