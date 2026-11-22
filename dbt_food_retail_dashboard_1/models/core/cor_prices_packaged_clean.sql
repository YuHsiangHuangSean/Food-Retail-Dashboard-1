SELECT
    id,
    product_code AS product,
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
    country_code,
    found_in_product_database,
    quantity,
    quantity_unit,
    categories,
    # labels_packaged,
    {{ keyword_in_list(
        'labels_packaged',
        ['en:organic']
    ) }} AS label_organic,
    {{ keyword_in_list(
        'labels_packaged',
        ['rainforest-alliance']
    ) }} AS label_rainforest_alliance,
    {{ keyword_in_list(
        'labels_packaged',
        ['en:fairtrade', 'en:fair-trade']
    ) }} AS label_fairtrade,
    {{ keyword_in_list(
        'labels_packaged',
        ['fsc']
    ) }} AS label_fsc,
    {{ keyword_in_list(
        'labels_packaged',
        ['msc']
    ) }} AS label_msc,
    {{ keyword_in_list(
        'labels_packaged',
        ['responsible-aquaculture-asc']
    ) }} AS label_asc,
    {{ keyword_in_list(
        'labels_packaged',
        ['rspo', 'roundtable-on-sustainable-palm-oil']
    ) }} AS label_rspo,
    UPPER(nutriscore_grade) AS nutriscore_grade,
    CASE
        WHEN greenscore_grade = 'a-plus'
            THEN 'A+'
        ELSE UPPER(greenscore_grade)
    END AS greenscore_grade,
    nova_group
FROM {{ ref('cor_prices_query_packaged') }}
WHERE
    found_in_product_database IS TRUE
    AND quantity IS NOT NULL
    AND quantity_unit IN ('g', 'ml')
#    AND nutriscore_grade IN ('a', 'b', 'c', 'd', 'e')
#    AND greenscore_grade IN ('a-plus', 'a', 'b', 'c', 'd', 'e', 'f')
#    AND nova_group IN (1, 2, 3, 4)