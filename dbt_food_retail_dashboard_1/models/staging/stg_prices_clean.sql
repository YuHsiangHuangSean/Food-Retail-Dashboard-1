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
    END AS label_fresh,
    price AS price,
    price_is_discounted AS discounted,
    price_without_discount AS price_original,
    CASE
        WHEN price_per = 'KILOGRAM'
            THEN 'kg'
        WHEN price_per = 'UNIT'
            THEN 'piece'
        WHEN price_per = 'LITER'
            THEN 'liter'
        ELSE NULL
    END AS quantity_unit_fresh,
    currency AS currency,
    date AS date,
    created AS created_at,
    updated AS updated_at,
    location_osm_address_country_code AS country_code,
    CASE
        WHEN product_source IS NULL
            THEN FALSE
        ELSE TRUE
    END AS found_in_product_database,
    product_product_quantity AS quantity_packaged,
    product_product_quantity_unit AS quantity_unit_packaged,
    product_labels_tags AS labels_packaged,
    product_nutriscore_grade AS nutriscore_grade,
    product_ecoscore_grade AS greenscore_grade,
    product_nova_group AS nova_group
FROM {{ source('raw', 'prices') }}
WHERE
    (price > 0 OR (price = 0 AND price_is_discounted IS TRUE))
    AND currency IS NOT NULL
    AND date IS NOT NULL
    AND proof_id IS NOT NULL
    AND location_osm_address_country_code IS NOT NULL