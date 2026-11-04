{{ config(
    description = "Country code and country should be 1-to-1 (except for 4 cases where the same country has multiple names)"
) }} 

SELECT
  location_osm_address_country_code,
  COUNT(DISTINCT location_osm_address_country),
  ARRAY_AGG(DISTINCT location_osm_address_country)
FROM {{ source('raw', 'prices')}}
WHERE
    location_osm_address_country_code NOT IN ('CH', 'DZ', 'PH', 'US')
GROUP BY location_osm_address_country_code
HAVING 
    COUNT(DISTINCT location_osm_address_country) > 1
ORDER BY location_osm_address_country_code