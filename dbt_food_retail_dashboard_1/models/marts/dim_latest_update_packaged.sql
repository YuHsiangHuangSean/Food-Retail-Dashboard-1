SELECT 
    MAX(updated_at) AS latest_update_at
FROM {{ ref('cor_prices_packaged_clean') }}