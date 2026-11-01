# Load products from local directory to BigQuery

from datetime import datetime
import duckdb

t0 = datetime.now()

# Query necessary columns

con = duckdb.connect()
con.execute("""
    COPY (
        SELECT
            brands,
            categories_tags,
            code,
            countries_tags,
            created_t,
            environmental_score_data,
            environmental_score_grade,
            environmental_score_score,
            food_groups_tags,
            ingredients_analysis_tags,
            labels_tags,
            last_updated_t,
            nova_group,
            nutriscore_grade,
            nutriscore_score,
            product_name,
            product_quantity_unit,
            product_quantity
        FROM read_parquet(
            'load_data/products.parquet' 
        )
    )
    TO 'load_data/products_18cols.parquet'
    (FORMAT PARQUET)
""")

con.close()

# Load products into BigQuery

t1 = datetime.now()
print(t1-t0)