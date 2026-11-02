# Load products from local directory to BigQuery

from datetime import datetime
import duckdb
from google.cloud import bigquery

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
# Right now it would take 11 GB of the logical storage in BigQuery 

client = bigquery.Client()

table_id = "ecommerce-dashboard-1.raw.products_18cols"

with open("load_data/products_18cols.parquet", "rb") as file:
    job = client.load_table_from_file(
        file,
        table_id,
        job_config=bigquery.LoadJobConfig(
            source_format=bigquery.SourceFormat.PARQUET,
            write_disposition="WRITE_TRUNCATE"
        )
    )

job.result()

t1 = datetime.now()
print(t1-t0)