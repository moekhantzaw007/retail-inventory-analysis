# Retail Inventory & Sales Analysis (In Progress)

An analysis of retail sales and inventory data using SQL, Python, and (coming soon) a Power BI/Tableau dashboard.

**Business question:** Where is the business losing money to overstock or stock-outs, and how reliable is the demand forecasting process?

**Status:** SQL cleaning and Python EDA complete. Dashboard and business recommendations in progress.

## Key findings so far

- Revenue is evenly distributed across categories, regions, and stores (within a 3% spread) — no single segment drives disproportionate performance.
- Demand forecasts overestimate actual sales by about 3.7% of units (370,168 units over 2 years), worth roughly $20.4M at average price.
- This forecasting bias is consistent across all 5 categories and stable across all 24 months — not improving or worsening over time.
- Inventory runs lean, at about 2 days of supply on average, with a 10.2% near-stockout rate (days where units sold reached 90%+ of inventory on hand).
- Discounts and promotions show no measurable effect on units sold.

## Files

| File | Description |
|---|---|
| `retail_store_inventory.csv` | Raw dataset |
| `inventory_cleaning.sql` | Data cleaning and validation in MySQL |
| `inventory_clean.csv` | Cleaned data exported from SQL |
| `retail_eda.ipynb` | Exploratory analysis in Python |

## Tools

MySQL, Python (pandas)

## Data source

[Retail Store Inventory Forecasting Dataset](https://www.kaggle.com/datasets/anirudhchauhan/retail-store-inventory-forecasting-dataset) on Kaggle — a synthetic dataset of 73,100 daily store-product records across 5 stores, 20 products, 5 categories, and 4 regions (2022-01-01 to 2024-01-01).

## Next steps

- Build a Power BI/Tableau dashboard
- Write business recommendations with estimated impact
- Add Excel summary with pivot tables

## Author

Moe Khant Zaw
