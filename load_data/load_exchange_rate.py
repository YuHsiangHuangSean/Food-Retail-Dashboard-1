# write into the same csv file
import pandas as pd
import requests
from io import StringIO

url = "https://data-api.ecb.europa.eu/service/data/EXR/M.BGN+CZK+DKK+HUF+PLN+RON+SEK+ISK+NOK+CHF+HRK.EUR.SP00.A?startPeriod=2009-04-01"

# Headers to store the content negotiation setting for the format of the output file.
headers = {"Accept": "text/csv"}

# Perform the GET request with SSL verification disabled
response = requests.get(url, headers=headers, verify=False)

# Check if the request was successful
if response.status_code == 200:
    # Write the content to a csv file
    with open("dbt_food_retail_dashboard_1/seeds/exchange_rates.csv", "wb") as file:
        file.write(response.content)
    print("Exchange rates have been written")
else:
    print(f": Failed to retrieve data. Status code {response.status_code}") 