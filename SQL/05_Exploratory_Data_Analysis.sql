
-- ===================================================================
-- Here is the complete Exploratory Data analysis of the whole dataset
-- Dataset overview


-- 1. How many total customers are in the Customers_Clean table?

SELECT 
	COUNT(*) AS Total_Numberof_Customers
FROM Customers_Clean


-- 2. How many total complaints are recorded in the Complaints_Clean table?

SELECT 
	COUNT(*) AS Total_Numberof_Complaints
FROM Complaints_Clean



-- 3. How many agents are available?

SELECT 
	COUNT(*) AS Total_Agents
FROM Agents_Clean



-- 4. How many total updates are recorded?

SELECT 
	COUNT(*) AS Total_Updates
FROM ComplaintUpdates_Clean




-- 5. How many unique customers have submitted complaints?

SELECT 
	COUNT(DISTINCT(CustomerID)) AS Total_Unique_Customers
FROM Complaints_Clean




-- 6. How many customers belong to each CustomerSegment?

SELECT 
	CustomerSegment,
	COUNT(*) AS Customer_BySegment
FROM Customers_Clean
GROUP BY CustomerSegment
ORDER BY Customer_BySegment DESC





-- 7. How many customers are there in each city?

SELECT 
	City,
	COUNT(*) AS Customer_ByCity
FROM Customers_Clean
GROUP BY City
ORDER BY Customer_ByCity DESC





-- 8. What is the distribution of customers by AccountStatus?

SELECT 
	AccountStatus,
	COUNT(*) AS Customer_ByAccountStatus
FROM Customers_Clean
GROUP BY AccountStatus
ORDER BY Customer_ByAccountStatus DESC




-- 9. How many customers joined in each year?

SELECT 
	YEAR(JoinDate) AS Join_year,
	COUNT(*) AS Customer_ByYear
FROM Customers_Clean
WHERE JoinDate IS NOT NULL
GROUP BY YEAR(JoinDate)
ORDER BY Customer_ByYear DESC





-- 10. Which cities have the highest number of customers?

SELECT 
	City,
	COUNT(*) AS Total_Customers
FROM Customers_Clean
GROUP BY City
ORDER BY Total_Customers DESC




-- 11. How many complaints belong to each IssueCategory?

SELECT 
	IssueCategory,
	COUNT(*) AS Total_Complaints
FROM Complaints_Clean
WHERE IssueCategory != 'n/a'
GROUP BY IssueCategory
ORDER BY Total_Complaints DESC





-- 12. What are the most common IssueSubcategories?

SELECT 
	IssueSubcategory,
	COUNT(*) AS Common_Issues
FROM Complaints_Clean
GROUP BY IssueSubcategory
ORDER BY Common_Issues DESC




-- 13. How many complaints are recorded for each Priority level?

SELECT 
	[Priority],
	COUNT(*) AS Total_Complaints
FROM Complaints_Clean
GROUP BY [Priority]
ORDER BY Total_Complaints DESC





-- 14. What is the distribution of complaints by Status?

SELECT 
	[Status],
	COUNT(*) AS Status_Distribution
FROM Complaints_Clean
GROUP BY [Status]
ORDER BY Status_Distribution DESC





-- 15. How many complaints were submitted through each Channel?

SELECT 
	Channel,
	COUNT(*) AS ComplaintsThrough_Channel
FROM Complaints_Clean
GROUP BY Channel
ORDER BY ComplaintsThrough_Channel DESC





-- 16. How many complaints are associated with each ProductService?

SELECT 
	ProductService,
	COUNT(*) AS ComplaintsThrough_ProdService
FROM Complaints_Clean
GROUP BY ProductService
ORDER BY ComplaintsThrough_ProdService DESC





-- 17. How many complaints were received each month?

SELECT 
	YEAR(ComplaintDate) AS [Year],
	DATENAME(MONTH, ComplaintDate) AS [Month],
	COUNT(*) AS Total_Complaints
FROM Complaints_Clean
WHERE ComplaintDate IS NOT NULL
GROUP BY YEAR(ComplaintDate), DATENAME(MONTH, ComplaintDate)
ORDER BY YEAR(ComplaintDate), DATENAME(MONTH, ComplaintDate)





-- 18. How many complaints were received in each year?

SELECT 
	YEAR(ComplaintDate) AS [Year],
	COUNT(*) AS Total_Complaints
FROM Complaints_Clean
WHERE ComplaintDate IS NOT NULL
GROUP BY YEAR(ComplaintDate)
ORDER BY YEAR(ComplaintDate) 





-- 19. What is the distribution of complaints by Reopened status?

SELECT 
	Reopened,
	COUNT(*) AS Total_Complaints
FROM Complaints_Clean
GROUP BY Reopened
ORDER BY Total_Complaints DESC





-- 20. What is the average ResolutionHours for complaints with a recorded resolution time?

SELECT 
	AVG(ResolutionHours) AS AvgResolutionTime
FROM Complaints_Clean
WHERE ResolutionHours IS NOT NULL






-- 21. How many agents belong to each Team?

SELECT 
	Team,
	COUNT(*) AS Total_Agents
FROM Agents_Clean
WHERE Team !='n/a'
GROUP BY Team
ORDER BY Total_Agents DESC






-- 22. What is the distribution of agents by AgentStatus?

SELECT 
	AgentStatus,
	COUNT(*) AS Total_Agents
FROM Agents_Clean
GROUP BY AgentStatus
ORDER BY Total_Agents DESC





-- 23. How many complaints are assigned to each agent?

SELECT 
	ac.AgentID,
	ac.AgentName,
	COUNT(cc.ComplaintID) AS Total_Complaints
FROM Agents_Clean ac
LEFT JOIN Complaints_Clean cc
	ON ac.AgentID = cc.AgentID
GROUP BY ac.AgentID, ac.AgentName
ORDER BY Total_Complaints DESC





-- 24. Which agents have handled the highest number of complaints?


SELECT TOP 3
	ac.AgentID,
	ac.AgentName,
	COUNT(cc.ComplaintID) AS Total_Complaints
FROM Agents_Clean ac
LEFT JOIN Complaints_Clean cc
	ON ac.AgentID = cc.AgentID
GROUP BY ac.AgentID, ac.AgentName
ORDER BY Total_Complaints DESC





-- 25. What is the distribution of SatisfactionRating?

SELECT 
	SatisfactionRating,
	COUNT(*) AS Total_Count
FROM Complaints_Clean
GROUP BY SatisfactionRating
ORDER BY Total_Count DESC





-- 27. What is the average ResolutionHours for each IssueCategory?

SELECT 
	IssueCategory,
	AVG(ResolutionHours) AS AvgResolutionHours
FROM Complaints_Clean
WHERE IssueCategory IS NOT NULL
GROUP BY IssueCategory
ORDER BY AvgResolutionHours DESC
 





-- 29. How many complaints have received 1, 2, 3, 4, 5, and 6 updates?
SELECT
    U.TotalUpdates,
    COUNT(*) AS TotalComplaints
FROM
(
    SELECT
        C.ComplaintID,
        COUNT(U.UpdateID) AS TotalUpdates
    FROM dbo.Complaints_Clean AS C
    LEFT JOIN dbo.ComplaintUpdates_Clean AS U
        ON C.ComplaintID = U.ComplaintID
    GROUP BY C.ComplaintID
) AS U
GROUP BY U.TotalUpdates
ORDER BY U.TotalUpdates







-- 30. What percentage of complaints are Resolved, Pending, and Cancelled?
SELECT 
	*
FROM
(
SELECT 
	[Status],
	COUNT(*) AS Total_Complaints,
	CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS decimal(10,2)) AS Percentage
FROM Complaints_Clean
GROUP BY [Status]
)t 
WHERE [Status] IN ('Resolved','Pending','Cancelled')
ORDER BY Percentage DESC