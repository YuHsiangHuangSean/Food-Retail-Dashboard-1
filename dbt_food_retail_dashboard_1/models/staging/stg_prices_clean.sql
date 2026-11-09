SELECT
    id AS id,
    type AS product_type,
    product_code AS product_code,
    product_name AS product_name,
    SPLIT(category_tag, ':')[OFFSET(1)] AS category_fresh,
    CASE
        WHEN labels_tags.list[SAFE_OFFSET(0)].element = 'en:organic'
            THEN 'organic'
        ELSE NULL
    END AS label,
    price AS price,
    price_is_discounted AS discounted,
    price_without_discount AS price_original,
    CASE
        WHEN price_per = 'KILOGRAM'
            THEN 'kg'
        WHEN price_per = 'UNIT'
            THEN 'piece'
        ELSE NULL
    END AS unit,
    currency AS currency,
    date AS date,
    created AS created_at,
    updated AS updated_at,
    location_osm_address_country_code AS country_code
FROM {{ source('raw', 'prices') }}
WHERE
    (price > 0 OR (price = 0 AND price_is_discounted IS TRUE))
    AND currency IS NOT NULL
    AND date IS NOT NULL
    AND proof_id IS NOT NULL
    AND location_osm_address_country_code IS NOT NULL