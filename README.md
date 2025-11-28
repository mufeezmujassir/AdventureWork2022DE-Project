
---

# 🚀 AdventureWorks Azure Data Engineering Project

End-to-End Modern Data Platform using Azure Data Factory, Data Lake, Databricks, Synapse & Power BI

---

## 📌 **Project Overview**

This project demonstrates a complete **end-to-end data engineering solution** using the **AdventureWorksLT2022** dataset.
The architecture follows the **Medallion Lakehouse approach** (Bronze → Silver → Gold) for scalable, secure, and analytics-ready data processing.

The system automates ingestion, transformation, storage, analysis, and visualization using Azure cloud services.

---

## 🏗️ **Architecture Diagram**

Pipeline flow:

On-Prem SQL → Azure Data Factory → Azure Data Lake (Bronze → Silver → Gold) → Azure Databricks → Azure Synapse Analytics → Power BI
Security: Azure AD + Key Vault

---

## 🎯 **Objectives**

✔ Ingest data from On-Prem SQL database
✔ Perform ELT transformations using Azure Databricks
✔ Store and manage data using Delta Lake (Bronze, Silver, Gold)
✔ Build Serverless SQL Views in Synapse
✔ Visualize results with Power BI reports
✔ Use Key Vault and AAD for secure authentication
✔ Automate pipelines using ADF scheduled triggers

---

# 🧰 **Tech Stack**

### **Azure Services**

* Azure Data Factory (ADF)
* Azure Data Lake Storage Gen2 (ADLS)
* Azure Databricks
* Azure Synapse Serverless SQL
* Azure Key Vault
* Azure Active Directory (AAD)
* Power BI

### **Languages & Tools**

* PySpark
* SQL
* Delta Lake
* Power BI Desktop

---

# 🛠️ **Solution Workflow**

## **1️⃣ Data Ingestion — Bronze Layer (Raw)**

**Azure Data Factory** pulls data from:

* On-Prem SQL Database
  ➝ via Self-Hosted IR

Data is copied into:
`abfss://bronze@<datalake>.dfs.core.windows.net/AdventureWorksLT/`

ADF Pipeline features:

* Copy Activity
* Parameterized pipelines
* Scheduled trigger for daily ingestion

---

## **2️⃣ Data Transformation — Silver Layer (Cleaned)**

Processed using **Azure Databricks** notebooks.

### Transformations include:

* Converting column names to snake_case
* Type casting
* Null value handling
* Deduplication
* Formatting dates

Silver stored in:
`abfss://silver@<datalake>.dfs.core.windows.net/...`

---

## **3️⃣ Curated Business Layer — Gold Layer (Aggregated)**

Gold layer stores analytics-ready data, e.g.:

* Customer Sales Summary
* Product Sales Performance
* Yearly and Monthly Sales
* Fact & Dimension models

Gold stored in:
`abfss://gold@<datalake>.dfs.core.windows.net/...`

---

## **4️⃣ Synapse Analytics — Serverless SQL Views**

A stored procedure is used to dynamically create Serverless SQL Views for each table:

```sql
CREATE OR ALTER PROC CreateSQLServerlessView_gold @ViewName NVARCHAR(100)
AS
BEGIN
DECLARE @statement VARCHAR(MAX)
SET @statement=N'CREATE OR ALTER VIEW ' + @ViewName + ' AS
    SELECT * FROM 
    OPENROWSET(
        BULK ''https://<lake>.dfs.core.windows.net/gold/SalesLT/'+ @ViewName +'/',
        FORMAT = ''DELTA''
    ) AS [result]'

    EXEC (@statement)
END
```

These views connect Power BI directly to ADLS via Delta.

---

## **5️⃣ Power BI Reporting**

Power BI connects to **Synapse Serverless** via:

```
Server: <workspace>.sql.azuresynapse.net
Database: gold_db
```

\

# 🔐 **Security & Governance**

### 🔹 Azure Active Directory

All access handled using AAD identities.

### 🔹 Key Vault

Stores:

* SQL credentials
* Service Principal keys
* Databricks secrets

### 🔹 IAM Roles Used

For **Access Connector** (Databricks to ADLS):

| Role Name                     | Purpose                 |
| ----------------------------- | ----------------------- |
| Storage Blob Data Contributor | Read/Write to Lake      |
| Storage Blob Data Owner       | Optional (full control) |
| Storage Blob Data Reader      | Reading only            |

If you cannot see **Storage Blob Data Contributor**, reason:
➡ You need **Owner** or **User Access Administrator** role on the subscription/resource.

---

# 🎛️ **ADF Pipeline Scheduling**

A Daily Trigger runs:

* Incremental ingestion
* File movement
* Metadata-based execution

Logs and monitoring can be found in ADF Monitor pane.

---



---

# 📌 **Key Learnings**

* Implementing the Medallion Architecture
* Secure data ingestion and transformation
* Using Delta Lake for ACID data processing
* Building scalable Serverless SQL layers
* Automating cloud pipelines
* Developing analytics dashboards

---

