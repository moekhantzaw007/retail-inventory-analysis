-- Retail inventory data cleaning
-- Source: Kaggle Retail Store Inventory Forecasting Dataset

-- Look at the raw imported data
SELECT * 
FROM RETAIL_STORE.retail_store_inventory;


-- Create a typed staging table (raw import has no explicit types)
DROP TABLE IF EXISTS inventory;

CREATE TABLE `inventory` (
  `Date` text,
  `Store_ID` text,
  `Product_ID` text,
  `Category` text,
  `Region` text,
  `Inventory_Level` int DEFAULT NULL,
  `Units_Sold` int DEFAULT NULL,
  `Units_Ordered` int DEFAULT NULL,
  `Demand_Forecast` DECIMAL(10,2) DEFAULT NULL,
  `Price` DECIMAL(10,2) DEFAULT NULL,
  `Discount` int DEFAULT NULL,
  `Weather_Condition` text,
  `Holiday/Promotion` int DEFAULT NULL,
  `Competitor_Pricing` DECIMAL(10,2) DEFAULT NULL,
  `Seasonality` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Copy raw data into the typed table
INSERT inventory
SELECT * 
FROM retail_store_inventory;

SELECT *
FROM inventory;

-- Check row counts match (expect 73,100 both)
SELECT COUNT(*) FROM inventory;
SELECT COUNT(*) FROM retail_store_inventory;

-- Confirm columns lined up correctly
DESCRIBE retail_store_inventory;
DESCRIBE inventory;


-- Build final cleaned table:
-- fix Date to real DATE type, clip negative Demand_Forecast to 0, add Revenue
DROP TABLE IF EXISTS inventory_clean;

CREATE TABLE inventory_clean AS
SELECT
    STR_TO_DATE(Date, '%Y-%m-%d') AS Sale_Date,
    Store_ID,
    Product_ID,
    Category,
    Region,
    Inventory_Level,
    Units_Sold,
    Units_Ordered,
    CASE
        WHEN Demand_Forecast < 0 THEN 0
        ELSE Demand_Forecast
    END AS Demand_Forecast,
    Price,
    Discount,
    Weather_Condition,
    `Holiday/Promotion`,
    Competitor_Pricing,
    Seasonality,
	CAST(ROUND(Units_Sold * Price * (1 - Discount / 100.0), 2) AS DECIMAL(10,2)) AS Revenue
FROM inventory;

SELECT *
FROM inventory_clean;

-- Verify: row count still 73,100
SELECT COUNT(*)
FROM inventory_clean;

-- Verify: no negative forecasts remain
SELECT MIN(Demand_Forecast)
FROM inventory_clean;

-- Verify: dates converted correctly
SELECT Sale_Date
FROM inventory_clean
LIMIT 5;

-- Total revenue (result: 494,971,374.76)
SELECT SUM(Revenue)
FROM inventory_clean;

-- Revenue by category
SELECT Category, SUM(Revenue) AS total_revenue
FROM inventory_clean
GROUP BY Category
ORDER BY total_revenue DESC;

-- Revenue by store
SELECT Store_ID, SUM(Revenue) AS total_revenue
FROM inventory_clean
GROUP BY Store_ID
ORDER BY total_revenue DESC;

-- Stock-out risk: days where units sold equals (or nearly equals) inventory level
SELECT COUNT(*) AS near_stockout_days
FROM inventory_clean
WHERE Units_Sold >= Inventory_Level * 0.9;

-- Average days of supply by category (inventory ÷ average daily units sold)
SELECT Category,
ROUND(AVG(Inventory_Level) / NULLIF(AVG(Units_Sold), 0), 1) AS avg_days_of_supply
FROM inventory_clean
GROUP BY Category
ORDER BY avg_days_of_supply ASC;












