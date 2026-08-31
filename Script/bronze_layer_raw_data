/* ======================================================
   DATABASE SETUP & BRONZE LAYER INGESTION
   Author: Sakina Kaidawala
   Description: Creates the database schema, defines the raw 
   bronze layer table structure, and bulk loads the synthetic 
   Kaggle supermarket inventory dataset via LOAD DATA INFILE.
   ======================================================
   1) Create database
   2) Create table (bronze layer)
   3) Insert all raw data into the table
   ====================================================== */

CREATE DATABASE supermarket_inventory;
USE supermarket_inventory;
SHOW VARIABLES LIKE '%secure%';

DROP TABLE IF EXISTS b_smarket_inventory;
CREATE TABLE b_smarket_inventory (
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

-- MAKE sure your CSV file is stored at uploads folder in your mysql files
TRUNCATE TABLE b_smarket_inventory;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/supermarket_inventory_data2.csv'
INTO TABLE b_smarket_inventory
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(`Date`,ProductID,ProductName,Category,Supplier,UnitPrice,StockQuantity,StockValue,ReorderLevel,ReorderQuantity,UnitsSold,SalesValue,@RAW_LastSoldDate,LastRestockDate,NextRestockDate,DeliveryTimeDays,DeliveryStatus
)SET LastSoldDate = NULLIF(@RAW_LastSoldDate,'') ;

SELECT *
FROM b_smarket_inventory;


