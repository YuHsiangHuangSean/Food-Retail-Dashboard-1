{{ test_w_fail_rate(
    "found_in_product_database IS NOT NULL",
    "found_in_product_database IS NOT NULL AND quantity IS NULL", 
    ref('cor_prices_query_packaged'), 
    0.2
) }}