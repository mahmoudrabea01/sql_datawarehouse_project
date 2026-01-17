# sql_datawarehouse_project
Building a modern data warehouse with SQL server, including ETL processes, data modeling and analytics

## Data Architecture
The data architecture for this project follows Medallion Architecture Bronze, Silver, and Gold layers:
<img width="1050" height="684" alt="image" src="https://github.com/user-attachments/assets/ad00d85f-f9b4-42d5-b89b-325528afd7fd" />
Bronze Layer: Stores raw data as-is from the source systems. Data is ingested from CSV Files into SQL Server Database.

Silver Layer: This layer includes data cleansing, standardization, and normalization processes to prepare data for analysis.

Gold Layer: Houses business-ready data modeled into a star schema required for reporting and analytics.

.
## Project Overview
This project involves:

Data Architecture: Designing a Modern Data Warehouse Using Medallion Architecture Bronze, Silver, and Gold layers.

ETL Pipelines: Extracting, transforming, and loading data from source systems into the warehouse.

Data Modeling: Developing fact and dimension tables optimized for analytical queries.

Analytics & Reporting: Creating SQL-based reports and dashboards for actionable insights.

Project Requirements

Building the Data Warehouse (Data Engineering)

Objective

Develop a modern data warehouse using SQL Server to consolidate sales data, enabling analytical reporting and informed decision-making.

Specifications

Data Sources: Import data from two source systems (ERP and CRM) provided as CSV files.

Data Quality: Cleanse and resolve data quality issues prior to analysis.

Integration: Combine both sources into a single, user-friendly data model designed for analytical queries.

Scope: Focus on the latest dataset only; historization of data is not required.

Documentation: Provide clear documentation of the data model to support both business stakeholders and analytics teams.

## BI: Analytics & Reporting (Data Analysis)
Objective

Develop SQL-based analytics to deliver detailed insights into:

### Customer Behavior

### Product Performance

### Sales Trends

These insights empower stakeholders with key business metrics, enabling strategic decision-making.




