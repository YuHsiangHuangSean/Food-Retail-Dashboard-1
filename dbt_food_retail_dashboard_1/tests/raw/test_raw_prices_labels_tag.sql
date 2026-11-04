{{ config(
    description = "The label column should only contain empty lists, NULL, and ['en:organic']. If new labels are found, workflow has to change"
) }} 

SELECT
    id AS id,
    labels_tags AS labels
FROM {{ source('raw', 'prices')}}
WHERE
    ARRAY_LENGTH(labels_tags.list) > 1
    OR (
        ARRAY_LENGTH(labels_tags.list) = 1
        AND labels_tags.list[SAFE_OFFSET(0)].element IS DISTINCT FROM 'en:organic'
    )