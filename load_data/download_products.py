# Download products from https://huggingface.co/datasets/openfoodfacts/product-database to local directory

from datetime import datetime
from pathlib import Path
import requests

t0 = datetime.now()

url = "https://huggingface.co/datasets/openfoodfacts/product-database/resolve/main/food.parquet"

output = Path("load_data/products.parquet")

with requests.get(url, stream=True, timeout=(30, 120)) as response:
    response.raise_for_status()

    with open(output, "wb") as file:
        for chunk in response.iter_content(chunk_size=1024 * 1024):
            if chunk:
                file.write(chunk)

t1 = datetime.now()
print(t1-t0)