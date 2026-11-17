SELECT 
    {{ agg_group_columns() }},
    quantity,
    quantity_unit,
    label_organic,
    label_rainforest_alliance,
    label_fairtrade,
    label_fsc,
    label_msc,
    label_asc,
    label_rspo,
    nutriscore_grade,
    greenscore_grade,
    nova_group,
    price_eur,
    price_original_eur,
    updated_at
FROM {{ ref('cor_prices_packaged_clean') }}