
-- =========================================================
-- Creating Database

CREATE DATABASE Cust_Ser_Comp_Analysis
GO
USE Cust_Ser_Comp_Analysis
GO




-- =========================================================
-- Creating Tables
CREATE TABLE dbo.Customers_Raw
(
    CustomerID VARCHAR(50),
    CustomerName VARCHAR(150),
    Email VARCHAR(150),
    Phone VARCHAR(50),
    City VARCHAR(100),
    CustomerSegment VARCHAR(50),
    JoinDate VARCHAR(100),
    AccountStatus VARCHAR(50)
);




CREATE TABLE dbo.Complaints_Raw
(
    ComplaintID VARCHAR(50),
    CustomerID VARCHAR(50),
    AgentID VARCHAR(50),
    ComplaintDate VARCHAR(100),
    ResolutionDate VARCHAR(100),
    IssueCategory VARCHAR(100),
    IssueSubcategory VARCHAR(100),
    Priority VARCHAR(50),
    Status VARCHAR(50),
    Channel VARCHAR(50),
    ProductService VARCHAR(100),
    ResolutionHours VARCHAR(50),
    SatisfactionRating VARCHAR(50),
    Reopened VARCHAR(50),
    ComplaintDescription VARCHAR(500)
);





CREATE TABLE dbo.Agents_Raw
(
    AgentID VARCHAR(50),
    AgentName VARCHAR(150),
    Team VARCHAR(100),
    AgentStatus VARCHAR(50)
);




CREATE TABLE dbo.ComplaintUpdates_Raw
(
    UpdateID VARCHAR(50),
    ComplaintID VARCHAR(50),
    UpdateDate VARCHAR(100),
    UpdateType VARCHAR(100),
    UpdateDescription VARCHAR(500),
    UpdatedBy VARCHAR(100)
);








-- Inserting data into the tables
TRUNCATE TABLE dbo.Customers_Raw;
BULK INSERT dbo.Customers_Raw
FROM 'D:\Data Analysis\Data_Warehouse_Projects\Customer-Service-Complaint-Analysis\Dataset\Customers_Raw.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK,
    CODEPAGE = '65001'
);

SELECT *
FROM Customers_Raw





TRUNCATE TABLE dbo.Complaints_Raw;
BULK INSERT dbo.Complaints_Raw
FROM 'D:\Data Analysis\Data_Warehouse_Projects\Customer-Service-Complaint-Analysis\Dataset\Complaints_Raw.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK,
    CODEPAGE = '65001'
);

SELECT *
FROM Complaints_Raw





TRUNCATE TABLE dbo.Agents_Raw;
BULK INSERT dbo.Agents_Raw
FROM 'D:\Data Analysis\Data_Warehouse_Projects\Customer-Service-Complaint-Analysis\Dataset\Agents_Raw.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK,
    CODEPAGE = '65001'
);

SELECT *
FROM Agents_Raw







TRUNCATE TABLE dbo.ComplaintUpdates_Raw;
BULK INSERT dbo.ComplaintUpdates_Raw
FROM 'D:\Data Analysis\Data_Warehouse_Projects\Customer-Service-Complaint-Analysis\Dataset\ComplaintUpdates_Raw.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK,
    CODEPAGE = '65001'
);





-- Verify all tables
SELECT 'Customers_Raw' AS TableName, COUNT(*) AS TotalRecords
FROM dbo.Customers_Raw

UNION ALL

SELECT 
    'Customer_Raw', COUNT(*)
FROM Customers_Raw

UNION ALL

SELECT 
    'Complaints_Raw', COUNT(*)
FROM Complaints_Raw

UNION ALL

SELECT 
    'Agents_Raw', COUNT(*)
FROM Agents_Raw

UNION ALL

SELECT 
    'ComplaintUpdates_Raw', COUNT(*)
FROM ComplaintUpdates_Raw
