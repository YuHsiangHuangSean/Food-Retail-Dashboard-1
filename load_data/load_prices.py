# Load prices from https://huggingface.co/datasets/openfoodfacts/open-prices to BigQuery

import duckdb

con = duckdb.connect()

con.execute("""
    COPY (
        SELECT
            *
        FROM read_parquet(
            'hf://datasets/openfoodfacts/open-prices/prices.parquet' 
        )
    )
    TO 'load_data/prices.parquet'
    (FORMAT PARQUET)
""")

from google.cloud import bigquery

client = bigquery.Client()

table_id = "ecommerce-dashboard-1.raw.prices"

with open("load_data/prices.parquet", "rb") as file:
    job = client.load_table_from_file(
        file,
        table_id,
        job_config=bigquery.LoadJobConfig(
            source_format=bigquery.SourceFormat.PARQUET,
            write_disposition="WRITE_TRUNCATE"
        )
    )

job.result()