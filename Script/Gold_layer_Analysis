/* ======================================================
   EXPLORATORY DATA ANALYSIS (EDA) SCRIPT
   Author: Sakina Kaidawala
   Description: Analyzes the clean silver layer supermarket dataset 
   to uncover supply chain bottlenecks, critical stockouts, trapped 
   capital, sell-through rates, and algorithmic ordering inefficiencies.
   ====================================================== */

-- ==================================
-- EDA 
-- ==================================
-- Which category suffer the most delays
SELECT category,
count(ProductID) total_products,
AVG(DeliveryTimeDays) AVG_Delivery_Days,
SUM(CASE WHEN DeliveryStatus = 'delayed' THEN 1 ELSE 0 END) Delayed_items,
SUM(CASE WHEN DeliveryStatus = 'delayed' THEN 1 ELSE 0 END) / count(ProductID) *100 delayed_rate 
FROM s_smarket_inventory
GROUP BY Category
ORDER BY 5 DESC;

-- ==========================================
-- shortfall quantity
-- ==========================================

SELECT
ProductID,
ProductName,
Category,
Supplier,
StockQuantity,
ReorderLevel,
(ReorderLevel - StockQuantity ) AS shortfall_Quantity
FROM s_smarket_inventory
WHERE DeliveryStatus = 'delayed' AND StockQuantity <= ReorderLevel
ORDER BY shortfall_Quantity DESC;

-- ==================================
-- total capital stuck in opration
-- ==================================
SELECT
category,
COUNT(ProductID) total_product,
SUM(ReorderQuantity) total_quantity_delayed,
SUM(ReorderQuantity*UnitPrice) total_amount_stuck
FROM s_smarket_inventory
WHERE DeliveryStatus = 'delayed'
GROUP BY Category
ORDER BY SUM(ReorderQuantity*UnitPrice) DESC;

-- ===========================================
-- Sell-Through Rate (STR)
-- ===========================================
SELECT
Category,
SUM(UnitsSold) AS total_unit_sold,
SUM(StockQuantity) AS total_quantity,
SUM(StockQuantity + UnitsSold) AS total_unit_available,
(SUM(UnitsSold)/SUM((StockQuantity + UnitsSold))) * 100 AS rate,
SUM(StockValue) AS total_stock_value
FROM s_smarket_inventory
WHERE (StockQuantity + UnitsSold) > 0
	AND UnitsSold < 10
	AND StockQuantity > 50
GROUP BY Category
ORDER BY total_stock_value DESC;

-- ===========================================
-- top 3 selling products by category
-- ===========================================
WITH CTE_revenue AS (
	SELECT
	ProductID,
	ProductName,
	Category,
	UnitsSold,
	SalesValue,
	DENSE_RANK() OVER(PARTITION BY category ORDER BY SalesValue DESC) AS rank_no
	FROM s_smarket_inventory)
SELECT *
FROM CTE_revenue
WHERE rank_no <= 3;

-- ===========================================
-- Low selling products by category 
-- ===========================================

WITH CTE_revenue AS (
	SELECT
	ProductID,
	ProductName,
	Category,
	UnitsSold,
	SalesValue,
	DENSE_RANK() OVER(PARTITION BY category ORDER BY SalesValue) AS rank_no
	FROM s_smarket_inventory)
SELECT *
FROM CTE_revenue
WHERE rank_no <= 3;

-- ===================================================
-- which products are over ordered
-- ===================================================
SELECT
ProductID,
ProductName,
category,
UnitsSold,
ReorderQuantity,
(ReorderQuantity - UnitsSold) AS excess_order_quantity,
(ReorderQuantity * UnitPrice) AS capital_wasted
FROM s_smarket_inventory
WHERE ReorderQuantity > (UnitsSold * 5)
	AND UnitsSold > 0
ORDER BY capital_wasted DESC;
