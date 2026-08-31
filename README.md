
Supermarket Supply Chain & Inventory Optimization
A SQL Data Warehouse Integration and Exploratory Data Analysis Project
Author: Sakina Kaidawala

🚨 Note on Data Source: This project relies on AI-generated synthetic data from Kaggle. While the supply chain scenarios, financial formulas, and operational bottlenecks analyzed here reflect real-world business challenges, the specific supplier names and transaction records are purely simulated.

Project Overview
This repository showcases an end-to-end SQL data warehouse integration and exploratory data analysis (EDA) pipeline built in MySQL. To simulate the complexities of enterprise-scale retail operations, this project utilizes a synthetic, AI-generated dataset sourced from Kaggle.

By working with this robust 10,000-row synthetic dataset, this project demonstrates how to transform raw, fragmented operational data into a structured "silver layer" ready for executive-level business intelligence. The analysis uncovers critical supply chain bottlenecks, isolates over $2.4 million in trapped capital, and exposes algorithmic restock inefficiencies to optimize inventory flow.

Technical Stack
Database: MySQL

Key SQL Techniques: Stored Procedures, Common Table Expressions (CTEs), Window Functions (DENSE_RANK()), Bulk Data Ingestion (LOAD DATA INFILE), Complex String Manipulation, and Mathematical Validation.

Repository Structure
This project is broken down into three core SQL scripts, designed to be executed sequentially:

1. Database Setup & Bronze Layer (01_bronze_layer_ingestion.sql)
Initializes the supermarket_inventory database.

Defines the schema for the raw data.

Utilizes LOAD DATA INFILE for rapid bulk insertion of the Kaggle CSV dataset into the b_smarket_inventory table.

2. Silver Layer ETL & Data Cleaning (02_silver_layer_etl.sql)
Implements a stored procedure (load_clean_inventory_data) to act as an automated ETL pipeline.

Standardizes heavily fragmented vendor names using nested REPLACE(), TRIM(), and SUBSTRING_INDEX() functions.

Audits and recalculates derived financial columns (StockValue, SalesValue) to ensure 100% mathematical integrity.

Validates chronological business logic (e.g., ensuring NextRestockDate does not occur before LastRestockDate).

Handles NULL conversions for invalid negative integers in price and quantity columns.

3. Exploratory Data Analysis (03_exploratory_data_analysis.sql)
The final analysis queries the clean s_smarket_inventory table to answer critical business questions and generate actionable insights:

Supply Chain Bottlenecks: Calculates delay rates by category to find which departments suffer the most transit failures.

Trapped Capital: Quantifies the exact dollar amount of inventory stuck in delayed transit (identifying massive operational bottlenecks in Snacks and Dairy).

Critical Stockouts: Filters delayed items against the ReorderLevel to find items actively missing from store shelves.

Dead Stock & Shrinkage (Sell-Through Rate): Calculates the true sell-through rate to flag highly perishable items (like Frozen Pizza and Bread) that have high stock volume but near-zero sales, representing an imminent 100% financial loss.

Top Revenue Drivers: Uses DENSE_RANK() partitioned by category to find the top 3 highest-grossing MVPs in every department.

Algorithmic Restock Inefficiency: Audits automated purchasing logic to find items where the system is programmed to over-order volume that is 5x greater than historical sales, preventing future wasted capital.

How to Run This Project
Download the synthetic Kaggle dataset (supermarket_inventory_data2.csv) and place it in your MySQL server's Uploads directory (or update the file path in Script 01).

Execute the 01_bronze_layer_ingestion.sql script to build the database and load the raw data.

Execute the 02_silver_layer_etl.sql script to create and call the data cleaning stored procedure.

Run the individual queries in 03_exploratory_data_analysis.sql to view the business insights.
