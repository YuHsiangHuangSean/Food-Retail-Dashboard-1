{{ test_w_fail_rate(
    "type = 'PRODUCT'",
    "type = 'PRODUCT' AND product_source IS NULL", 
    source('raw', 'prices'), 
    0.1
) }}