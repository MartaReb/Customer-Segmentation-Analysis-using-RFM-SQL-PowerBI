/*
===============================================================================
Project: Customer Segmentation Analysis using RFM
Description: This script aggregates transactional data to calculate Recency, 
             Frequency, and Monetary metrics per customer. It then scores 
             the metrics (1-5) using NTILE and categorizes customers into 
             actionable business segments.
===============================================================================
*/

-- Step 1: Aggregate raw data to calculate raw RFM metrics
WITH sales_data AS 
(
    SELECT 
        CustomerID, 
        DATEDIFF('2020-12-31', MAX(OrderDate)) AS Recency, 
        COUNT(DISTINCT OrderNumber) AS Frequency, 
        ROUND(SUM(UnitPrice * OrderQuantity * (1 - DiscountApplied)), 2) AS Monetary
    FROM regional_sales_data
    GROUP BY CustomerID
),

-- Step 2: Assign scores from 1 to 5 using window functions
scored_data AS 
(
    SELECT 
        CustomerID,
        NTILE(5) OVER(ORDER BY Recency DESC) AS r_score,
        NTILE(5) OVER(ORDER BY Frequency ASC) AS f_score,
        NTILE(5) OVER(ORDER BY Monetary ASC) AS m_score
    FROM sales_data
)

-- Step 3: Concatenate scores and map them into business personas
SELECT 
    CustomerID,
    CONCAT(r_score, f_score, m_score) AS rfm_score,
    CASE 
        WHEN r_score = 5 AND f_score >= 4 AND m_score >= 4 THEN 'Champions'
        WHEN r_score <= 2 AND f_score >= 4 AND m_score >= 4 THEN 'At Risk'
        WHEN f_score >= 4 THEN 'Loyal Customers'
        WHEN r_score = 1 AND f_score <= 2 AND m_score <= 2 THEN 'Hibernating'
        ELSE 'Others'
    END AS customers_segmentation
FROM scored_data;