{{ test_w_fail_rate(
    "TRUE",
    "price IS NULL
    OR price < 0
    OR (price_is_discounted IS FALSE AND price = 0)", 
    source('raw', 'prices'), 
    0.001
) }}