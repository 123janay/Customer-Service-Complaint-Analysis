
-- =============================================================================
-- Creating Tables where we will insert the clean data after doing data profiling

USE Cust_Ser_Comp_Analysis


IF OBJECT_ID('dbo.Customers_Clean', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Customers_Clean
    (
        CustomerID VARCHAR(50),
        CustomerName VARCHAR(150),
        Email VARCHAR(150),
        Phone VARCHAR(50),
        City VARCHAR(100),
        CustomerSegment VARCHAR(50),
        JoinDate DATE,
        AccountStatus VARCHAR(50)
    );
END
ELSE
BEGIN
    TRUNCATE TABLE dbo.Customers_Clean;
END;


SELECT *
FROM Customers_Clean



-- ==============================================================
-- Creating Agents_Clean table

IF OBJECT_ID('dbo.Agents_Clean', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Agents_Clean
    (
        AgentID VARCHAR(50),
        AgentName VARCHAR(150),
        Team VARCHAR(100),
        AgentStatus VARCHAR(50)
    );
END
ELSE
BEGIN
    TRUNCATE TABLE dbo.Agents_Clean;
END;

SELECT *
FROM Agents_Clean






-- ==============================================================
-- Creating Complaints_Clean table

IF OBJECT_ID('dbo.Complaints_Clean', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Complaints_Clean
    (
        ComplaintID VARCHAR(50),
        CustomerID VARCHAR(50),
        AgentID VARCHAR(50),
        ComplaintDate DATE,
        ResolutionDate DATE,
        IssueCategory VARCHAR(100),
        IssueSubcategory VARCHAR(100),
        Priority VARCHAR(50),
        Status VARCHAR(50),
        Channel VARCHAR(50),
        ProductService VARCHAR(100),
        ResolutionHours DECIMAL(10,2),
        SatisfactionRating INT,
        Reopened VARCHAR(20),
        ComplaintDescription VARCHAR(500)
    );
END
ELSE
BEGIN
    TRUNCATE TABLE dbo.Complaints_Clean;
END;

SELECT *
FROM Complaints_Clean



use Cust_Ser_Comp_Analysis

-- ============================================================
-- Creating ComplaintUpdates_Clean table
IF OBJECT_ID('dbo.ComplaintUpdates_Clean', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.ComplaintUpdates_Clean
    (
        UpdateID VARCHAR(50),
        ComplaintID VARCHAR(50),
        UpdateDate DATETIME2,
        UpdateType VARCHAR(100),
        [UpdateText] VARCHAR(500),
        UpdatedBy VARCHAR(100)
    );
END
ELSE
BEGIN
    TRUNCATE TABLE dbo.ComplaintUpdates_Clean;
END;

SELECT *
FROM ComplaintUpdates_Clean