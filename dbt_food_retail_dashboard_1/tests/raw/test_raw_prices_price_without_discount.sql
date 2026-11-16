{{ config(
    severity = "warn"
) }}

{{ test_w_fail_rate(
    "price_is_discounted IS TRUE",
    "price_is_discounted IS TRUE AND price_without_discount is NULL", 
    source('raw', 'prices'), 
    0.2
) }}