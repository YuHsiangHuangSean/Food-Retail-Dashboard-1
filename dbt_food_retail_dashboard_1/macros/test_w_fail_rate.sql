{% macro test_w_fail_rate(total_rows_condition, failed_rows_condition, table, threshold) %}
WITH stats AS (
    SELECT
        COUNTIF({{ total_rows_condition }}) AS total_rows,
        COUNTIF({{ failed_rows_condition }}) AS failed_rows
    FROM {{ table }}
)

SELECT
    total_rows,
    failed_rows,
    SAFE_DIVIDE(failed_rows, total_rows) AS failure_rate
FROM stats
WHERE SAFE_DIVIDE(failed_rows, total_rows) >= {{ threshold }}
{% endmacro %}