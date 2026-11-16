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
    END AS unit,
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
    product_product_quantity AS product_quantity,
    product_product_quantity_unit AS product_quantity_unit,
    EXISTS(
        SELECT 1
        FROM UNNEST(product_labels_tags.list) AS tag
        WHERE tag.element LIKE '%en:organic%'
    ) AS label_organic,
    EXISTS(
        SELECT 1
        FROM UNNEST(product_labels_tags.list) AS tag
        WHERE tag.element LIKE '%rainforest-alliance%'
    ) AS label_rainforest_alliance,
    EXISTS(
        SELECT 1
        FROM UNNEST(product_labels_tags.list) AS tag
        WHERE tag.element LIKE '%en:fairtrade%' OR tag.element LIKE '%en:fair-trade%'
    ) AS label_fairtrade,
    EXISTS(
        SELECT 1
        FROM UNNEST(product_labels_tags.list) AS tag
        WHERE tag.element LIKE '%fsc%'
    ) AS label_fsc,
    EXISTS(
        SELECT 1
        FROM UNNEST(product_labels_tags.list) AS tag
        WHERE tag.element LIKE '%msc%'
    ) AS label_msc,
    EXISTS(
        SELECT 1
        FROM UNNEST(product_labels_tags.list) AS tag
        WHERE tag.element LIKE '%responsible-aquaculture-asc%'
    ) AS label_asc,
    EXISTS(
        SELECT 1
        FROM UNNEST(product_labels_tags.list) AS tag
        WHERE tag.element LIKE '%rspo%' OR tag.element LIKE '%roundtable-on-sustainable-palm-oil%'
    ) AS label_rspo,
    # product_labels_tags
    product_nutriscore_grade AS nutriscore_grade
FROM {{ source('raw', 'prices') }}
WHERE
    (price > 0 OR (price = 0 AND price_is_discounted IS TRUE))
    AND currency IS NOT NULL
    AND date IS NOT NULL
    AND proof_id IS NOT NULL
    AND location_osm_address_country_code IS NOT NULL
    AND (type = 'PRODUCT' AND product_source IS NOT NULL)
    AND (type = 'PRODUCT' AND product_product_quantity IS NOT NULL)
    AND (type = 'PRODUCT' AND product_product_quantity_unit IN ('g', 'ml'))
    AND (type = 'PRODUCT' AND product_nutriscore_grade IN ('a', 'b', 'c', 'd', 'e'))