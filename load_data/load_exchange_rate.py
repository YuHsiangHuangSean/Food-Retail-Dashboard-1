import requests

for currency in ['BGN', 'CZK', 'DKK', 'HUF', 'PLN', 'RON', 'SEK', 'ISK', 'NOK', 'CHF', 'HRK']:

    # WS URL and dataset query
    url = "https://data-api.ecb.europa.eu/service/data/EXR/M.CZK.EUR.SP00.A?startPeriod=2009-04-01"
    url = "https://data-api.ecb.europa.eu/service/data/EXR/M." + currency + ".EUR.SP00.A?startPeriod=2009-04-01"

    # Headers to store the content negotiation setting for the format of the output file.
    headers = {"Accept": "text/csv"}

    # Perform the GET request with SSL verification disabled
    response = requests.get(url, headers=headers, verify=False)

    # Check if the request was successful
    if response.status_code == 200:
        # Write the content to a csv file.
        path = "dbt_food_retail_dashboard_1/seeds/EUR_to_" + currency + ".csv"
        with open(path, 'wb') as file:
            file.write(response.content)
        print("Exchange rate for " + currency + " has been written")
    else:
        print(f"Failed to retrieve data: Status code {response.status_code}") 