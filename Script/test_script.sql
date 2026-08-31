/* ==============================================================================
 TEST SCRIPT FOR DATA CLEANING & VALIDATION SCRIPT TEST SCRIPT
 Author: Sakina Kaidawala
 Description: Standardizes supplier names, audits financial logic, 
 and validates chronological integrity for the silver layer data warehouse.
-- ======================================================
*/
-- checking for duplicate entry
SELECT *
FROM (SELECT *,
	ROW_NUMBER() OVER(PARTITION BY `Date`,ProductID,ProductName,Category,Supplier,UnitPrice,StockQuantity,
									StockValue,ReorderLevel,ReorderQuantity,UnitsSold,SalesValue,LastSoldDate,
									LastRestockDate,NextRestockDate,DeliveryTimeDays,DeliveryStatus ORDER BY `date`) row_no
	FROM b_smarket_inventory)t
WHERE row_no > 1;

-- checking for duplicate products
SELECT ProductID,
COUNT(*)
FROM b_smarket_inventory
WHERE Productid IS NOT NULL
GROUP BY ProductID
HAVING COUNT(*) > 1;

-- checking of nulls
SELECT *
FROM b_smarket_inventory
WHERE ProductID IS NULL;

SELECT DISTINCT Category
FROM b_smarket_inventory;

-- Standardized fragmented supplier names 
SELECT DISTINCT supplier,
substring_index(REPLACE(REPLACE(REPLACE(Supplier,',',' '),'-',' '),'  ',' '),' ',1) AS clean_supplier
FROM b_smarket_inventory;

-- Standardized Supplier names
SELECT DISTINCT 
    Supplier AS Original_Name,
    TRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Supplier,',',' '),'-',' '),'  ',' '), ' Inc', ''), ' LLC', ''), ' Ltd', ''), ' Group', ''), ',', '')) AS Soft_Clean_Supplier
FROM b_smarket_inventory;

-- checking for null or negative price
SELECT unitprice
FROM b_smarket_inventory
WHERE unitprice < 0 OR unitprice IS NULL
;

-- checking for null or negative quantity
SELECT StockQuantity
FROM b_smarket_inventory
WHERE StockQuantity < 0 OR StockQuantity IS NULL
;

-- checking for null or business logic
SELECT *
FROM b_smarket_inventory
WHERE UnitPrice*StockQuantity != StockValue;

-- applying business logic fixing errors and  to fill the null values
SELECT
CASE
	WHEN StockValue = UnitPrice*StockQuantity THEN StockValue
	ELSE UnitPrice*StockQuantity
END AS StockValue
FROM b_smarket_inventory;

-- checking for null in reorder level
SELECT *
FROM b_smarket_inventory
WHERE ReorderLevel IS NULL OR  ReorderLevel = '' OR ReorderLevel < 0 AND ReorderQuantity<= 0;

-- checking for null in reorder quantity
SELECT *
FROM b_smarket_inventory
WHERE ReorderQuantity IS NULL OR  ReorderQuantity = '' OR ReorderQuantity < 0;

-- checking for errors in sale values
SELECT *
FROM b_smarket_inventory
WHERE SalesValue != UnitsSold*UnitPrice;

-- checking if last sold date is greater than current date
SELECT *
FROM b_smarket_inventory
WHERE LastSoldDate > CURDATE();

-- checking if last restock date is greater than current date and next restock date
SELECT *
FROM b_smarket_inventory
WHERE LastRestockDate > CURDATE() OR LastRestockDate > NextRestockDate;

-- checking if next  restock date is less than last restock date
SELECT *
FROM b_smarket_inventory
WHERE NextRestockDate < LastRestockDate;

-- checking for impossible data and nulls
SELECT * 
FROM b_smarket_inventory
WHERE DeliveryTimeDays < 0 OR DeliveryTimeDays IS NULL;

-- checking for spelling or other errors
SELECT DISTINCT DeliveryStatus
FROM b_smarket_inventory;
