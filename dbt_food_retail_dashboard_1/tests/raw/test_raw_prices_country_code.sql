{{ config(
    store_failures = true
) }}

SELECT
  location_osm_address_country_code AS country_code,
  COUNT(DISTINCT location_osm_address_country) AS country_count,
  ARRAY_AGG(DISTINCT location_osm_address_country) AS country_names
FROM {{ source('raw', 'prices')}}
WHERE
    location_osm_address_country_code NOT IN ('CH', 'DZ', 'PH', 'US', 'LY')
GROUP BY location_osm_address_country_code
HAVING 
    COUNT(DISTINCT location_osm_address_country) > 1
ORDER BY location_osm_address_country_code