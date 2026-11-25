
-- ==================================================
-- Doing Data Profiling of all the tables and columns in details 
-- so that we can later insert the clean data into the clean tables.

USE Cust_Ser_Comp_Analysis
GO

-- Checking Duplicates in the ID column
SELECT 
	CustomerID,
	COUNT(*) AS TotalCustomer
FROM Customers_Raw
GROUP BY CustomerID
HAVING COUNT(*) > 1




-- Checking Null and Empty Spaces in the Customer Name column

SELECT *
FROM Customers_Raw
WHERE CustomerName IS NULL

SELECT 
	LEN(CustomerName) AS Cus_Len,
	LEN(TRIM(CustomerName)) Len_After_Trim,
	LEN(CustomerName) - LEN(TRIM(CustomerName)) AS Difference_In_Len
FROM Customers_Raw





-- Checking Null and Empty Spaces in the Customer Name column

SELECT *
FROM Customers_Raw
WHERE Email IS NULL OR Email = ''

SELECT *
FROM Customers_Raw
WHERE Email != TRIM(Email)





-- Checking issues in phone column

SELECT *
FROM Customers_Raw
WHERE Phone IS NULL

SELECT 
	Phone,
	COUNT(*) AS TotalNumbers
FROM Customers_Raw
GROUP BY Phone
HAVING COUNT(*) > 1





-- Checking issues in City column

SELECT 
	City,
	COUNT(*)
FROM Customers_Raw
GROUP BY City


SELECT 
	City,
	LEN(City) AS City_Len,
	LEN(TRIM(City)) AS Len_After_Trim,
	LEN(City) - LEN(TRIM(City)) AS Difference_Len
FROM Customers_Raw
WHERE LEN(City) - LEN(TRIM(City))>=1






-- Checking issues in CustomerSegment column

SELECT *
FROM Customers_Raw
WHERE CustomerSegment IS NULL OR CustomerSegment = ''







-- Checking issues in CustomerSegment column

SELECT *
FROM Customers_Raw
WHERE JoinDate IS NULL OR JoinDate = ''


SELECT
    MIN(TRY_CONVERT(DATE, JoinDate)) AS EarliestJoinDate,
    MAX(TRY_CONVERT(DATE, JoinDate)) AS LatestJoinDate
FROM dbo.Customers_Raw






-- Checking issues in CustomerSegment column

SELECT *
FROM Customers_Raw
WHERE AccountStatus IS NULL

SELECT 
	AccountStatus,
	CASE WHEN AccountStatus IS NULL THEN 'n/a'
		 ELSE AccountStatus
	END
FROM Customers_Raw




-- ==================================================
-- Doing data profiling for agents raw table
-- Doing data profiling for AgentID table  

SELECT 
	AgentID,
	COUNT(*) AS TotalId
FROM Agents_Raw
GROUP BY AgentID
HAVING COUNT(*) > 1

SELECT *
FROM Agents_Raw
WHERE AgentID = 'AG005'

SELECT *
FROM Agents_Raw 
WHERE AgentID != TRIM(AgentID)




-- Doing data profiling for AgentName table

SELECT 
	LEN(AgentName) AS len_Agent,
	LEN(TRIM(AgentName)) AS Len_After,
	LEN(AgentName) - LEN(TRIM(AgentName))
FROM Agents_Raw
WHERE LEN(AgentName) - LEN(TRIM(AgentName)) >=1

SELECT *
FROM Agents_Raw
WHERE AgentName IS NULL OR AgentName = ''







-- Doing data profiling for AgentName table

SELECT *
FROM Agents_Raw
WHERE Team IS NULL OR TEAM = ''

SELECT 
	Team,
	COUNT(*)
FROM Agents_Raw
GROUP BY Team





-- Doing data profiling for AgentName table

SELECT 
	LEN(AgentStatus),
	LEN(TRIM(AgentStatus)),
	LEN(AgentStatus) - LEN(TRIM(AgentStatus))
FROM Agents_Raw

SELECT *
FROM Agents_Raw
WHERE AgentStatus != TRIM(AgentStatus)






-- ==================================================
-- Doing data profiling for Complaints_Raw table
-- Doing data profiling for ComplaintID Column

SELECT *
FROM Complaints_Raw
WHERE ComplaintID = 'COMP000079'

SELECT 
	ComplaintID,
	COUNT(*) AS TotalIDs
FROM Complaints_Raw
GROUP BY ComplaintID
HAVING COUNT(*) > 1







-- Doing data profiling for CustomerID Column

SELECT *
FROM Complaints_Raw
WHERE CustomerID IS NULL OR TRIM(CustomerID) = ''

SELECT *
FROM Complaints_Raw
WHERE CustomerID != TRIM(CustomerID)






-- Doing data profiling for AgentID Column

SELECT *
FROM Complaints_Raw
WHERE AgentID IS NULL OR AgentID = ''

SELECT *
FROM Complaints_Raw
WHERE AgentID != TRIM(AgentID)







-- Doing data profiling for ComplaintDate Column

SELECT *
FROM Complaints_Raw
WHERE ComplaintDate IS NULL


SELECT ComplaintDate
FROM dbo.Complaints_Raw
WHERE NULLIF(LTRIM(RTRIM(ComplaintDate)), '') IS NOT NULL
AND TRY_CONVERT(DATETIME2, ComplaintDate) IS NULL






-- Doing data profiling for ResolutionDate Column

SELECT ResolutionDate
FROM dbo.Complaints_Raw
WHERE NULLIF(LTRIM(RTRIM(ResolutionDate)), '') IS NOT NULL
AND TRY_CONVERT(DATETIME2, ResolutionDate) IS NULL






-- Doing data profiling for IssueCategory Column 

SELECT *
FROM Complaints_Raw
WHERE IssueCategory IS NULL

SELECT 
	IssueCategory,
	COUNT(*) AS Total
FROM Complaints_Raw
GROUP BY IssueCategory
HAVING COUNT(*) > 1







-- Doing data profiling for IssueCategory Column 

SELECT 
	IssueSubcategory,
	COUNT(*)
FROM Complaints_Raw
GROUP BY IssueSubcategory


SELECT *
FROM Complaints_Raw
WHERE IssueSubcategory != TRIM(IssueSubcategory)





-- Doing data profiling for IssueCategory Column 

SELECT *
FROM Complaints_Raw
WHERE IssueSubcategory IS NULL OR IssueSubcategory = ''

SELECT 
*
FROM Complaints_Raw
WHERE IssueSubcategory != TRIM(IssueSubcategory)







-- Doing data profiling for Priority Column 

SELECT *
FROM Complaints_Raw
WHERE Priority IS NULL

SELECT 
	Priority,
	COUNT(*)
FROM Complaints_Raw
GROUP BY Priority







-- Doing data profiling for Status Column 

SELECT 
	Status
FROM Complaints_Raw
WHERE Status IS NULL

SELECT DISTINCT 
	Status
FROM Complaints_Raw








-- Doing data profiling for Channel Column 

SELECT DISTINCT Channel
FROM Complaints_Raw

SELECT *
FROM Complaints_Raw
WHERE Channel IS NULL OR Channel = ''






-- Doing data profiling for ProductService Column 

SELECT DISTINCT ProductService
FROM Complaints_Raw






-- Doing data profiling for ResolutionHours Column 

SELECT *
FROM Complaints_Raw
WHERE ResolutionHours IS NULL

SELECT
    COUNT(*) AS TotalRecords,
    COUNT(ResolutionHours) AS NonNullValues,
    SUM(CASE WHEN ResolutionHours IS NULL THEN 1 ELSE 0 END) AS NullValues
FROM dbo.Complaints_Raw;

SELECT DISTINCT ResolutionHours
FROM dbo.Complaints_Raw
WHERE ResolutionHours IS NOT NULL
ORDER BY ResolutionHours







-- Doing data profiling for SatisfactionRating Column 

SELECT DISTINCT SatisfactionRating
FROM Complaints_Raw

SELECT 
	SatisfactionRating,
	COUNT(*) AS Total
FROM Complaints_Raw
GROUP BY SatisfactionRating
ORDER BY Total






-- Doing data profiling for Reopened Column 

SELECT DISTINCT Reopened
FROM Complaints_Raw

SELECT 
	Reopened,
	COUNT(*)
FROM Complaints_Raw
GROUP BY Reopened





-- Doing data profiling for Reopened Column 

SELECT DISTINCT ComplaintDescription
FROM Complaints_Raw

SELECT *
FROM Complaints_Raw
WHERE ComplaintDescription != TRIM(ComplaintDescription)










-- ==================================================
-- Doing data profiling for Complaints_Raw table
-- Doing data profiling for UpdateID Column


SELECT
    UpdateID,
    COUNT(*) AS TotalRecords
FROM dbo.ComplaintUpdates_Raw
GROUP BY UpdateID
HAVING COUNT(*) > 1

SELECT *
FROM ComplaintUpdates_Raw
WHERE UpdateID = 'UPD000020'





-- Doing data profiling for ComplaintID Column

SELECT 
	ComplaintID,
	COUNT(*) AS Total
FROM ComplaintUpdates_Raw
GROUP BY ComplaintID
HAVING COUNT(*) > 1








-- Doing data profiling for UpdateDate Column

SELECT UpdateID, ComplaintID, UpdateDate
FROM dbo.ComplaintUpdates_Raw
WHERE NULLIF(LTRIM(RTRIM(UpdateDate)), '') IS NOT NULL
  AND TRY_CONVERT(DATETIME2, UpdateDate) IS NULL








-- Doing data profiling for UpdateDate Column

SELECT 
	UpdateType,
	COUNT(*)
FROM ComplaintUpdates_Raw
GROUP BY UpdateType

SELECT *
FROM ComplaintUpdates_Raw
WHERE UpdateType != TRIM(UpdateType)






-- Doing data profiling for UpdateDescription Column

SELECT DISTINCT UpdateDescription
FROM ComplaintUpdates_Raw







-- Doing data profiling for UpdatedBy Column

SELECT DISTINCT UpdatedBy
FROM ComplaintUpdates_Raw


SELECT *
FROM ComplaintUpdates_Raw
WHERE UpdatedBy != TRIM(UpdatedBy)


