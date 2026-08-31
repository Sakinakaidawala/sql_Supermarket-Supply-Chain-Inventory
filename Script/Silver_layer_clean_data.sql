/* ======================================================
   SILVER LAYER ETL & DATA CLEANING PROCEDURE
   Author: Sakina Kaidawala
   Description: Creates the silver layer table and defines a 
   stored procedure to extract, transform, and load (ETL) data 
   from the bronze layer. Applies string standardization, financial 
   logic recalculations, and chronological date validations.
   ======================================================
   1) Create table (silver layer)
   2) Define stored procedure for data transformation
   3) Apply business logic, nullify invalid data, and clean text
   4) Execute procedure to populate the clean silver layer
   ====================================================== */


DROP TABLE IF EXISTS s_smarket_inventory;
CREATE TABLE s_smarket_inventory (
	`Date` DATE,
    ProductID VARCHAR(50),
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Supplier VARCHAR(100),
    UnitPrice DECIMAL(10,2),
    StockQuantity INT,
    StockValue DECIMAL(10,2),
    ReorderLevel INT,
    ReorderQuantity INT,
    UnitsSold INT,
    SalesValue DECIMAL(10,2),
	LastSoldDate DATE,
    LastRestockDate DATE,
    NextRestockDate DATE,
    DeliveryTimeDays INT,
    DeliveryStatus VARCHAR(50)
);
DELIMITER $$

DROP PROCEDURE IF EXISTS load_clean_inventory_data$$
CREATE PROCEDURE load_clean_inventory_data ()
BEGIN
	TRUNCATE TABLE s_smarket_inventory;
	INSERT INTO s_smarket_inventory (
		`date`,
		ProductID,
		ProductName,
		category,
		Supplier,
		UnitPrice,
		StockQuantity,
		StockValue,
		ReorderLevel,
		ReorderQuantity,
		UnitsSold,
		SalesValue,
		LastSoldDate,
		LastRestockDate,
		NextRestockDate,
		DeliveryTimeDays,
		DeliveryStatus) 
        
		SELECT 
		`date`,
		ProductID,
		TRIM(ProductName) AS ProductName,
		TRIM(category) AS category,
		TRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Supplier,',',' '),'-',' '),'  ',' '), ' Inc', ''), ' LLC', ''), ' Ltd', ''), ' Group', '')) AS Supplier,
		CASE
			WHEN UnitPrice < 0 THEN NULL
			ELSE UnitPrice
		END AS UnitPrice,
		CASE
			WHEN StockQuantity < 0 THEN NULL
			ELSE StockQuantity
		END AS StockQuantity,
		CASE
			WHEN StockValue = UnitPrice*StockQuantity THEN StockValue
			ELSE UnitPrice*StockQuantity
		END AS StockValue,
		CASE
			WHEN ReorderLevel < 0 THEN NULL
			ELSE ReorderLevel
		END AS ReorderLevel,
		CASE
			WHEN ReorderQuantity < 0 THEN NULL
			ELSE ReorderQuantity
		END AS ReorderQuantity,
		CASE
			WHEN UnitsSold < 0 THEN NULL
			ELSE UnitsSold
		END AS UnitsSold,
		CASE
			WHEN SalesValue = UnitPrice*UnitsSold THEN SalesValue
			ELSE UnitPrice*UnitsSold
		END AS SalesValue,
		CASE
			WHEN LastSoldDate > CURDATE() THEN NULL
			ELSE LastSoldDate
		END AS LastSoldDate,
		CASE
			WHEN LastRestockDate > NextRestockDate THEN NULL
			ELSE LastRestockDate
		END AS LastRestockDate,
		CASE
			WHEN NextRestockDate < LastRestockDate THEN NULL
			ELSE NextRestockDate
		END AS NextRestockDate,
		CASE
			WHEN DeliveryTimeDays < 0 THEN NULL
			ELSE DeliveryTimeDays
		END AS DeliveryTimeDays,
		CASE
			WHEN DeliveryStatus LIKE '%del%' THEN 'Delayed'
            WHEN DeliveryStatus LIKE '%time%' THEN 'On Time'
            ELSE 'Partial Delivery'
		END AS DeliveryStatus
		FROM b_smarket_inventory;
END $$
DELIMITER ;
CALL load_clean_inventory_data();
SELECT * FROM s_smarket_inventory;
