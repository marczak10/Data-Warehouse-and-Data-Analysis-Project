# Data Warehouse and Data Analytics Project

Welcome to the **Data Warehouse and Data Analysis Project** repository!  
This project demonstrates a comprehensive data warehousing and analytics solution—from building a data warehouse to generating actionable insights. Designed as a portfolio project, it highlights industry best practices in data engineering and analytics.

---

## 🏗️ Data Architecture

The data architecture for this project follows the Medallion Architecture with three distinct layers: **Bronze**, **Silver**, and **Gold**.

![Data Architecture](Data%20Warehouse/documents/data_architecture.png)

1. **Bronze Layer**  
   Stores raw data as-is from the source systems. Data is ingested from CSV files into a SQL Server database.
2. **Silver Layer**  
   Applies data cleansing, standardization, and normalization processes to refine data for analysis.
3. **Gold Layer**  
   Houses business-ready data, modeled into a star schema that is optimized for reporting and analytics.

---

## 📖 Project Overview

This project is divided into two main parts:

1. **Data Engineering**  
   Focused on designing and building a modern data warehouse to consolidate and process sales data.
2. **Data Analysis**  
   Concentrates on developing SQL-based reports and creating PowerBI dashboards that deliver actionable insights into customer behavior, product performance, and sales trends.

---

## 🚀 Project Parts

### 1) Building the Data Warehouse (Data Engineering)

#### Objective
Develop a modern data warehouse using SQL Server to integrate data from multiple source systems and enable robust analytical reporting.

#### Specifications
- **Data Sources:**  
  Import data from two primary source systems (ERP and CRM) provided as CSV files.
- **Data Quality:**  
  Implement data cleansing steps to resolve quality issues before analysis.
- **Integration:**  
  Merge data from both sources into a unified, user-friendly model.
- **Scope:**  
  Use the latest dataset only; historical data tracking is not required.
- **Documentation:**  
  Detail the data model, processes, and design decisions to support both technical teams and business stakeholders.

---

### 2) BI: Analytics & Reporting (Data Analysis)

#### Objective
Develop SQL queries and PowerBI dashboards to provide detailed insights and drive decision-making by analyzing:

- **Customer Behavior**
- **Product Performance**
- **Sales Trends**

These efforts help stakeholders access key business metrics and gain strategic insights.

---

## 📊 Reports & Dashboards

Below are the two PowerBI dashboards created during this project.

### 1) 

![Customer Dashboard](Data%20Analysis/reports/Customer%20Dashboard.png)

This dashboard provides:
- Total Customers, Orders, and Revenue
- Breakdown of customers by country, age group, and segment
- Detailed visualizations of sales by country, age group, and segment
- Top 10 customers based on total sales

### 2) 

![Product Dashboard](Data%20Analysis/reports/Product%20Dashboard.png)

This dashboard showcases:
- Product-level metrics, including total products, orders, and average revenue per product
- Product segmentation by various categories and lines
- Sales by segment, age group, and category
- Top 10 products with their sales and orders

---

## 🛡️ License

This project is licensed under the [MIT License](LICENSE). You are free to use, modify, and share this project with proper attribution.
