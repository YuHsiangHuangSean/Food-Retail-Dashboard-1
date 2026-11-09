{% macro agg_group_columns() %}
    product,
    label,
    discounted,
    # FORMAT_DATE('%Y-%m', date),
    date,
    country_code 
{% endmacro %}