{% macro keyword_in_list(column_name, keywords) %}
    EXISTS (
        SELECT 1
        FROM UNNEST({{ column_name }}.list) AS item
        WHERE
            {% for keyword in keywords %}
                item.element LIKE '%{{ keyword }}%'
                {% if not loop.last %} OR {% endif %}
            {% endfor %}
    )
{% endmacro %}