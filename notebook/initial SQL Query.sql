
---CREATE THE USER WITH LOGIN

CREATE LOGIN luke WITH PASSWORD= '123456'
CREATE USER luke for login luke

---Give the Access permission for Particular table
USE AdventureWorksLT2022;
GRANT SELECT ON SalesLT.Address to luke;

--Give the Access Permission for all the tables
GRANT SELECT ON SCHEMA::SalesLT TO luke;


--get the tables which are in the SalesLT schemas

SELECT s.name AS SchemaName,
t.name AS TableName
From sys.tables t
INNER JOIN sys.schemas s ON t.schema_id=s.schema_id
WHERE s.name='SalesLT'


SELECT * FROM sys.tables