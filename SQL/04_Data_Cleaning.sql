
-- Sorting out the issues found in the data profiling 
-- and then inserting them into the clean tables


-- =====================================================
-- Inserting Clean data into the customer_clean table
INSERT INTO dbo.Customers_Clean
(
	CustomerID,
	CustomerName,
	Email,
	Phone,
	City,
	CustomerSegment,
	JoinDate,
	AccountStatus
)
SELECT 
	CustomerID,
	CASE WHEN CustomerName IS NULL THEN 'n/a'
		 ELSE CustomerName
	END AS CustomerName,
	CASE WHEN Email IS NULL THEN 'n/a'
		 ELSE Email
	END AS Email,
	CASE WHEN TRIM(Phone) IN ('N/A', 'NA') THEN NULL
		 ELSE TRIM(Phone)
	END AS Phone,
	CASE WHEN TRIM(City) IN ('Lahore', 'lahore') Then 'Lahore'
		 ELSE TRIM(City)
	END AS City,
	CASE WHEN CustomerSegment IS NULL THEN 'n/a'
		 WHEN CustomerSegment IN ('Corp', 'Corporate') THEN 'Corporate'
		 ELSE CustomerSegment
	END AS CustomerSegment,
	CASE
        WHEN UPPER(LTRIM(RTRIM(JoinDate)))
             IN ('UNKNOWN', 'NA', 'N/A', 'NULL', 'NOT AVAILABLE', '-')
            THEN NULL

        WHEN LTRIM(RTRIM(JoinDate)) = ''
            THEN NULL

        ELSE TRY_CONVERT(
            DATE,
            REPLACE(LTRIM(RTRIM(JoinDate)), '/', '-'),
            23
        )
    END AS JoinDate,
	CASE WHEN AccountStatus IS NULL THEN 'n/a'
		 ELSE AccountStatus
	END
FROM 
(
SELECT 
	*,
	ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY CustomerID) AS Row_Num
FROM Customers_Raw
) AS D
WHERE Row_Num = 1

SELECT COUNT(*)
FROM Customers_Clean











-- =====================================================
-- Inserting clean data into Agent_Clean table

INSERT INTO dbo.Agents_Clean
(
	AgentID,
	AgentName,
	Team,
	AgentStatus
)
SELECT 
	AgentID,
	CASE WHEN AgentName IS NULL THEN 'n/a'
		 ELSE AgentName
	END AS AgentName,
	CASE WHEN Team IS NULL THEN 'n/a'
		 ELSE Team
	END AS Team,
	AgentStatus
FROM
(
SELECT 
	*,
	ROW_NUMBER() OVER (PARTITION BY AgentID ORDER BY AgentID) AS Agent_Rank
FROM Agents_Raw
) AS d
WHERE Agent_Rank = 1


SELECT *
FROM Agents_Clean







-- =====================================================
-- Inserting clean data into Complaints_Raw table
INSERT INTO dbo.Complaints_Clean
(
	ComplaintID,
	CustomerID,
	AgentID,
	ComplaintDate,
	ResolutionDate,
	IssueCategory,
	IssueSubcategory,
	Priority,
	Status,
	Channel,
	ProductService,
	ResolutionHours,
	SatisfactionRating,
	Reopened,
	ComplaintDescription
)
SELECT 
	ComplaintID,
	CustomerID,
	AgentID,
	CASE
        WHEN LTRIM(RTRIM(ComplaintDate)) IN
             ('2024-02-30', '31/11/2025', 'not a date')
            THEN NULL
        ELSE TRY_CONVERT(
            DATETIME2,
            LTRIM(RTRIM(ComplaintDate)),
            120
        )
    END AS ComplaintDate,
	CASE
    WHEN UPPER(LTRIM(RTRIM(ResolutionDate))) = 'UNKNOWN'
        THEN NULL

    WHEN LTRIM(RTRIM(ResolutionDate)) = '2025-13-01'
        THEN NULL

    WHEN LTRIM(RTRIM(ResolutionDate)) = '31/12/2025'
        THEN TRY_CONVERT(DATETIME2, ResolutionDate, 103)

    WHEN ResolutionDate IS NULL
        THEN NULL

    ELSE TRY_CONVERT(DATETIME2, ResolutionDate, 120)
END AS ResolutionDate,
	CASE WHEN IssueCategory IS NULL THEN 'n/a'
		 WHEN UPPER(LTRIM(RTRIM((IssueCategory)))) IN ('INTERNET CONNECTIVITY','INTERNET') THEN 'Internet Connectivity'
		 ELSE LTRIM(RTRIM(IssueCategory))
	END AS IssueCategory,
	IssueSubcategory,
	CASE WHEN Priority IS NULL THEN 'n/a'
		 WHEN Priority IN ('urgent','Critical') THEN 'Critical'
		 ELSE Priority
	END AS Priority,
	CASE WHEN Status IS NULL THEN 'n/a'
		 WHEN Status = 'RESOLVED ' THEN 'Resolved'
		 ELSE Status
	END AS Status,
		CASE WHEN Channel IS NULL THEN 'n/a'
		 ELSE Channel
	END AS Channel,
	ProductService,
	CASE
    WHEN TRY_CONVERT(DECIMAL(10,2), ResolutionHours) < 0
         OR TRY_CONVERT(DECIMAL(10,2), ResolutionHours) = 999.0
        THEN NULL
    ELSE TRY_CONVERT(DECIMAL(10,2), ResolutionHours)
END AS ResolutionHours,
	CASE
    WHEN TRY_CONVERT(DECIMAL(10,2), SatisfactionRating) BETWEEN 0 AND 5
        THEN TRY_CONVERT(INT, SatisfactionRating)
    ELSE NULL
END AS SatisfactionRating,
	CASE WHEN Reopened IS NULL THEN 'Unknown'
		 ELSE Reopened
	END AS Reopened,
	ComplaintDescription
FROM
(
	SELECT 
		*,
		ROW_NUMBER() OVER (PARTITION BY ComplaintID ORDER BY ComplaintID) AS Row_Num
	FROM Complaints_Raw
) AS D
WHERE Row_Num = 1

SELECT *
FROM Complaints_Clean










-- =====================================================
-- Inserting clean data into Complaints_Raw table

INSERT INTO dbo.ComplaintUpdates_Clean
(
	UpdateID,
	ComplaintID,
	UpdateDate,
	UpdateType,
	[UpdateText],
	UpdatedBy
)
SELECT 
	UpdateID,
	ComplaintID,
	CASE
    WHEN LTRIM(RTRIM(UpdateDate)) IN ('2025-02-30', 'bad date')
        THEN NULL
    ELSE TRY_CONVERT(DATETIME2, LTRIM(RTRIM(UpdateDate)))
END AS UpdateDate,
	CASE WHEN UpdateType IN ('Follow up','Customer Follow-up') THEN 'Customer Follow-up'
		 WHEN UpdateType IS NULL THEN 'n/a'
		 ELSE UpdateType
	END AS UpdateType,
	UpdateDescription,
	UpdatedBy
FROM
(
SELECT 
	*,
	ROW_NUMBER() OVER (PARTITION BY UpdateID ORDER BY UpdateID) AS Row_Num
FROM ComplaintUpdates_Raw
) AS D
WHERE Row_Num = 1

SELECT *
FROM ComplaintUpdates_Clean


