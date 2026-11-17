{% macro agg_group_columns() %}
    id,
    product,
    discounted,
    # FORMAT_DATE('%Y-%m', date),
    date,
    country_code 
{% endmacro %}