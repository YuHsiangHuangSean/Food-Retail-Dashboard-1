{{ test_w_fail_rate(
    "TRUE",
    "found_in_product_database IS NULL", 
    ref('cor_prices_query_packaged'), 
    0.1
) }}