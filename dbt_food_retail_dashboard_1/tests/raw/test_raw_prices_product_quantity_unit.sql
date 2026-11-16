{{ config(
    severity = "warn"
) }}

{{ test_w_fail_rate(
    "type = 'PRODUCT' AND product_source IS NOT NULL",
    "type = 'PRODUCT' AND product_source IS NOT NULL AND (product_product_quantity_unit IN ('g', 'ml')) IS NOT TRUE", 
    source('raw', 'prices'), 
    0.2
) }}