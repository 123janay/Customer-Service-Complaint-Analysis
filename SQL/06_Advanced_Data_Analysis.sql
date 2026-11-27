
-- Advanced Data Analysis

-- 1. What is the month-over-month percentage change in complaints, 
--    and which months experienced the highest growth?

WITH MonthlyComplaints AS
(
    SELECT
        DATEFROMPARTS(
            YEAR(ComplaintDate),
            MONTH(ComplaintDate),
            1
        ) AS ComplaintMonth,
        COUNT(*) AS TotalComplaints
    FROM dbo.Complaints_Clean
    WHERE ComplaintDate IS NOT NULL
    GROUP BY
        YEAR(ComplaintDate),
        MONTH(ComplaintDate)
),
MonthlyGrowth AS
(
    SELECT
        ComplaintMonth,
        TotalComplaints,
        LAG(TotalComplaints) OVER
        (
            ORDER BY ComplaintMonth
        ) AS PreviousMonthComplaints
    FROM MonthlyComplaints
)
SELECT
    ComplaintMonth,
    TotalComplaints,
    PreviousMonthComplaints,
    CAST(
        (TotalComplaints - PreviousMonthComplaints) * 100.0
        / NULLIF(PreviousMonthComplaints, 0)
        AS DECIMAL(10,2)
    ) AS GrowthPercentage
FROM MonthlyGrowth
ORDER BY ComplaintMonth









-- 2. Which days of the week receive the highest number of complaints?

SELECT 
    DATENAME(WEEKDAY, ComplaintDate) AS Week_Day,
    COUNT(*) AS Total_Complaints
FROM Complaints_Clean
WHERE ComplaintDate IS NOT NULL
GROUP BY DATENAME(WEEKDAY, ComplaintDate)
ORDER BY Total_Complaints DESC







-- 3. What is the monthly trend of resolved, pending, and cancelled complaints?

SELECT 
    YEAR(ComplaintDate) AS Years,
    MONTH(ComplaintDate) AS Months,
    SUM(CASE WHEN Status = 'Resolved'THEN 1 ELSE 0 END)  AS Resolved,
    SUM(CASE WHEN Status = 'Cancelled'THEN 1 ELSE 0 END)  AS Cancelled,
    SUM(CASE WHEN Status = 'Pending'THEN 1 ELSE 0 END)  AS Pending
FROM Complaints_Clean
GROUP BY  YEAR(ComplaintDate), MONTH(ComplaintDate)
ORDER BY  Years, Months






-- 4. Who are the top 10 customers based on the number of complaints submitted?

SELECT TOP 10
    c.CustomerID,
    c.CustomerName,
    c.City,
    COUNT(DISTINCT cc.ComplaintID) AS Total_Complaints
FROM Customers_Clean c
LEFT JOIN Complaints_Clean cc
    ON cc.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName, c.City
ORDER BY Total_Complaints DESC








-- 7. Which customers have submitted complaints across multiple issue categories?

SELECT 
    c.CustomerID,
    c.CustomerName,
    COUNT(DISTINCT cc.IssueCategory) AS Total_Categories,
    COUNT(DISTINCT cc.ComplaintID) AS Total_Complaints
FROM Customers_Clean c
LEFT JOIN Complaints_Clean cc
    ON cc.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName
HAVING COUNT(DISTINCT cc.IssueCategory) > 1
ORDER BY Total_Categories DESC








-- 8. What percentage of customers have submitted more than one complaint?

WITH CustomerComplaints AS
(
    SELECT
        CustomerID,
        COUNT(*) AS TotalComplaints
    FROM dbo.Complaints_Clean
    WHERE CustomerID IS NOT NULL
    GROUP BY CustomerID
)
SELECT
    COUNT(*) AS CustomersWithComplaints,

    SUM(CASE WHEN TotalComplaints > 1
        THEN 1 ELSE 0 END) AS RepeatCustomers,

    CAST(
        SUM(CASE WHEN TotalComplaints > 1
            THEN 1.0 ELSE 0 END) * 100
        / NULLIF(COUNT(*), 0)
        AS DECIMAL(10,2)
    ) AS RepeatCustomerPercentage

FROM CustomerComplaints;









-- 9. Which customer segments have the highest complaint rate compared with their total customer population?

WITH SegmentCustomers AS
(
    SELECT
        CustomerSegment,
        COUNT(*) AS TotalCustomers
    FROM dbo.Customers_Clean
    GROUP BY CustomerSegment
),
SegmentComplaints AS
(
    SELECT
        C.CustomerSegment,
        COUNT(P.ComplaintID) AS TotalComplaints
    FROM dbo.Customers_Clean AS C
    LEFT JOIN dbo.Complaints_Clean AS P
        ON C.CustomerID = P.CustomerID
    GROUP BY C.CustomerSegment
)
SELECT
    S.CustomerSegment,
    S.TotalCustomers,
    P.TotalComplaints,
    CAST(
        P.TotalComplaints * 1.0
        / NULLIF(S.TotalCustomers, 0)
        AS DECIMAL(10,2)
    ) AS ComplaintsPerCustomer
FROM SegmentCustomers AS S
INNER JOIN SegmentComplaints AS P
    ON S.CustomerSegment = P.CustomerSegment
ORDER BY ComplaintsPerCustomer DESC;









-- 10. Which cities have the highest average complaints per customer?

With CityComplaints AS
(
SELECT 
    c.City,
    COUNT(cc.ComplaintID) AS Total_Complaints,
    COUNT(DISTINCT c.CustomerID) AS Total_Customers
FROM Customers_Clean c
LEFT JOIN Complaints_Clean cc
    ON c.CustomerID = cc.CustomerID
GROUP BY City
)
SELECT 
    City,
    Total_Complaints,
    Total_Customers,
    CAST(Total_Complaints *1.0 / NULLIF(Total_Customers, 0) AS DECIMAL(10,2)) AS AverageComplaintPerCustomer
FROM CityComplaints 
ORDER BY AverageComplaintPerCustomer DESC







-- 11. Rank agents based on the number of complaints handled by each agent.
-- There are multiple agents having the same rank we can use dense_rank too for it
SELECT 
    ac.AgentID,
    ac.AgentName,
    ac.Team,
    COUNT(cc.ComplaintID) AS TotalComplaints,
    RANK() OVER (ORDER BY COUNT(cc.ComplaintID) DESC) AS AgentRank
FROM Agents_Clean ac
LEFT JOIN Complaints_Clean cc
    ON cc.AgentID = ac.AgentID
GROUP BY ac.AgentID, ac.AgentName, ac.Team
ORDER BY AgentRank








-- 12. Which agents have the highest average resolution time?

SELECT 
    ac.AgentID,
    ac.AgentName,
    COUNT(cc.ComplaintID) AS TotalComplaints,
    CAST(AVG(cc.ResolutionHours) AS DECIMAL(10,2)) AS AverageResolutionTime
FROM Agents_Clean ac
LEFT JOIN Complaints_Clean cc
     ON cc.AgentID = ac.AgentID
WHERE cc.ResolutionHours IS NOT NULL
GROUP BY ac.AgentID, ac.AgentName
ORDER BY AverageResolutionTime DESC









-- 13. Which agents have the highest percentage of resolved complaints?

SELECT 
    c.AgentID,
    c.AgentName,
    COUNT(cc.ComplaintID) AS TotalComplaints,
    SUM (CASE WHEN cc.Status = 'Resolved' THEN 1 ELSE 0 END) AS TotalResolvedComplaints,
    SUM (CASE WHEN cc.Status = 'Resolved' THEN 1 ELSE 0 END) * 100 / NULLIF(COUNT(cc.ComplaintID),0) AS ResolutionPercentage
FROM Agents_Clean c
LEFT JOIN Complaints_Clean cc
    ON cc.AgentID = c.AgentID
GROUP BY c.AgentID, c.AgentName
ORDER BY ResolutionPercentage DESC







-- 14. Which agents have the highest reopened complaint rate?

SELECT 
    c.AgentID,
    c.AgentName,
    COUNT(cc.ComplaintID) AS TotalComplaints,
    SUM (CASE WHEN cc.Reopened = 'Yes' THEN 1 ELSE 0 END) AS ReopendComplaints,
    SUM (CASE WHEN cc.Reopened = 'Yes' THEN 1 ELSE 0 END) * 100 / NULLIF(COUNT(cc.ComplaintID),0) AS ReopendPercentage
FROM Agents_Clean c
LEFT JOIN Complaints_Clean cc
    ON cc.AgentID = c.AgentID
GROUP BY c.AgentID, c.AgentName
ORDER BY ReopendPercentage DESC









-- 15. Which products or services have the highest percentage of unresolved complaints?

SELECT 
    ProductService,
    COUNT(*) AS TotalComplaints,
    SUM(CASE WHEN Status <> 'Resolved' THEN 1 ELSE 0 END) AS UnresolvedComplaints,
     SUM(CASE WHEN Status <> 'Resolved' THEN 1 ELSE 0 END) * 100 / NULLIF(COUNT(*),0) AS UnresolvedPercentage
FROM Complaints_Clean
WHERE ProductService IS NOT NULL
GROUP BY ProductService
ORDER BY UnresolvedPercentage DESC









-- 16. What percentage of complaints are resolved within 24 hours, 
-- between 24 and 48 hours, and after 48 hours?

SELECT 
    COUNT(*) AS TotalComplaintTime,
    SUM(CASE WHEN ResolutionHours <= 24 THEN 1 ELSE 0 END) AS Within24hours,
    SUM(CASE WHEN ResolutionHours < 24 
        AND ResolutionHours <= 48 THEN 1 ELSE 0 END) AS Between24and48hours,
    SUM(CASE WHEN ResolutionHours > 48 THEN 1 ELSE 0 END) AS After48hours,
    SUM(CASE WHEN ResolutionHours <= 24 THEN 1 ELSE 0 END) * 100 / NULLIF(COUNT(*),0) AS Within24HoursPercentage,
    SUM(CASE WHEN ResolutionHours < 24 
        AND ResolutionHours <= 48 THEN 1 ELSE 0 END) * 100 / NULLIF(COUNT(*),0) AS Between24And48HoursPercentage,
    SUM(CASE WHEN ResolutionHours > 48 THEN 1 ELSE 0 END) * 100 / NULLIF(COUNT(*),0) AS After48HoursPercentage
FROM Complaints_Clean
WHERE ResolutionHours IS NOT NULL











-- 17. Which products have the highest number of complaints for each issue category?

WITH ProductIssues  AS 
(
SELECT 
    IssueCategory,
    ProductService,
    COUNT(*) AS TotalComplaints
FROM Complaints_Clean
WHERE IssueCategory IS NOT NULL AND ProductService != 'n/a'
GROUP BY IssueCategory, ProductService
),
ProductRanking AS
(
    SELECT 
        IssueCategory,
        ProductService,
        TotalComplaints,
        ROW_NUMBER() OVER (PARTITION BY IssueCategory ORDER BY TotalComplaints DESC) AS RankingProd
    FROM ProductIssues 
)
SELECT 
    IssueCategory,
    ProductService,
    TotalComplaints
FROM ProductRanking
WHERE RankingProd = 1
ORDER BY TotalComplaints DESC











-- 18. What percentage of complaints are reopened, and which issue 
-- categories have the highest reopening rate?

SELECT 
    IssueCategory,
    COUNT(*) AS TotalComplaints,
    SUM(CASE WHEN Reopened = 'Yes' THEN 1 ELSE 0 END) AS ReopenedComplaints,
    SUM(CASE WHEN Reopened = 'Yes' THEN 1 ELSE 0 END) * 100 / NULLIF(COUNT(*),0) AS ReopenedComplaintsPercentage
FROM Complaints_Clean
GROUP BY IssueCategory
ORDER BY ReopenedComplaintsPercentage DESC









-- 19. Which complaints required the highest number of updates before resolution?

SELECT TOP 10
    cc.ComplaintID,
    cc.IssueCategory,
    cc.[Status],
    COUNT(cu.UpdateID) AS TotalUpdates
FROM Complaints_Clean cc
LEFT JOIN ComplaintUpdates_Clean cu
    ON cu.ComplaintID = cc.ComplaintID
GROUP BY cc.ComplaintID, cc.IssueCategory, cc.[Status]
ORDER BY TotalUpdates DESC








-- 20. Which issue categories contribute the most to total complaints, 
--     total resolution hours, and customer dissatisfaction?

SELECT
    IssueCategory,

    COUNT(*) AS TotalComplaints,

    SUM(ResolutionHours) AS TotalResolutionHours,

    AVG(ResolutionHours) AS AverageResolutionHours,

    SUM(CASE
        WHEN SatisfactionRating <= 2 THEN 1
        ELSE 0
    END) AS LowSatisfactionComplaints,

    CAST(
        SUM(CASE
            WHEN SatisfactionRating <= 2 THEN 1.0
            ELSE 0
        END) * 100
        / NULLIF(COUNT(SatisfactionRating), 0)
        AS DECIMAL(10,2)
    ) AS LowSatisfactionPercentage

FROM dbo.Complaints_Clean
GROUP BY IssueCategory
ORDER BY TotalComplaints DESC;