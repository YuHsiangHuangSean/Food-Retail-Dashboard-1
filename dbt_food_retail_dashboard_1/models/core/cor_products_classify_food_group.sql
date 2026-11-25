WITH initial_aggregation AS (
    SELECT
        products.product,
        products.quantity,
        products.quantity_unit,
        products.categories,
        COUNT(DISTINCT mapping.food_group_1) AS food_groups_1_count,
        ARRAY_AGG(DISTINCT mapping.food_group_1 IGNORE NULLS) AS food_groups_1,
        COUNT(DISTINCT mapping.food_group_2) AS food_groups_2_count,
        ARRAY_AGG(DISTINCT mapping.food_group_2 IGNORE NULLS) AS food_groups_2,
        products.label_organic,
        products.label_rainforest_alliance,
        products.label_fairtrade,
        products.label_fsc,
        products.label_msc,
        products.label_asc,
        products.label_rspo,
        products.nutriscore_grade,
        products.greenscore_grade,
        products.nova_group
    FROM {{ ref('cor_products_packaged') }} AS products
    LEFT JOIN UNNEST(products.categories.list) AS category
        ON TRUE
    LEFT JOIN {{ ref('category_food_group_mapping') }} AS mapping
        ON category.element = mapping.category_tag
    GROUP BY ALL
)

SELECT
    product,
    quantity,
    quantity_unit,
    # categories,
    CASE
        WHEN food_groups_1_count = 0
            THEN NULL
        WHEN food_groups_1_count = 1
            THEN food_groups_1[SAFE_OFFSET(0)]
        WHEN food_groups_1_count > 1 AND 'Composite foods' IN UNNEST(food_groups_1)
            THEN 'Composite foods'
        ELSE 'Ambiguous'
    END AS food_group,
    CASE
        WHEN food_groups_2_count = 0
            THEN NULL
        WHEN food_groups_2_count = 1
            THEN food_groups_2[SAFE_OFFSET(0)]
        ELSE 'Ambiguous'
    END AS food_subgroup,
    label_organic,
    label_rainforest_alliance,
    label_fairtrade,
    label_fsc,
    label_msc,
    label_asc,
    label_rspo,
    nutriscore_grade,
    greenscore_grade,
    nova_group
FROM initial_aggregation