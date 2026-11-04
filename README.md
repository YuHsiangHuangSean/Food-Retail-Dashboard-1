# Food Retail Dashboard - What is Really Happening in Supermarkets

## Project overview
#OpenFoodFacts #DataAnalytics #ELTPipeline #DataVisualization #FoodPrices #FoodSustainability #OpenData #BigQuery #dbt

Open Food Facts is a free, open, and collaborative database of food products from around the world, built primarily on product and pricing data submitted by consumers through various channels.

The database offers a unique perspective on what is happening in supermarkets: which products are available across different markets, how prices vary and change over time, and the health and environmental characteristics of those products.

This dashboard aims to transform this data into actionable insights into food markets and consumption. It explores trends in food prices, the availability and affordability of healthier and more environmentally friendly products, and how rising living costs have influenced these dimensions over time.

## Data source
Over 340 thousand of [price data from Open Food Facts](https://prices.openfoodfacts.org/), available under the Open Database License.

Over 4.8 million of [product data from Open Food Facts](https://world.openfoodfacts.org/data), available under the Open Database License.

Both datasets are loaded from Hugging Face: [price](https://huggingface.co/datasets/openfoodfacts/open-prices), [product](https://huggingface.co/datasets/openfoodfacts/product-database)

## ELT workflow
1. Datasets are downloaded from Hugging Face and loaded into BigQuery. Further transformation and validation are managed using dbt Core (Done).

2. Data quality tests are applied to raw data to identify missing values, duplicates, and inconsistencies (Done).

3. Datasets are cleaned based on data quality issues identified in the previous tests (Done).

4. Datasets are transformed into a dashboard-ready relational data model (WIP).

5. Trends in food prices across time, markets, and health and environmental characteristics are visualized using Tableau (WIP).

6. Insights are generated from the dashboard (WIP).

## Automation
1. The data pipeline from raw data in Hugging Face to an interactive Tableau dashboard is automated using GitHub Actions on a weekly/monthly update schedule (WIP). 
