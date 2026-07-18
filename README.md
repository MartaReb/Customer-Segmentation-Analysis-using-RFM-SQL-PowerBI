# Customer-Segmentation-Analysis-using-RFM-SQL-PowerBI

### 1. Business Context
   
The objective of this project was to optimize marketing spend and maximize Campaign ROI for "Sales Everything". Facing budget constraints, the Marketing Director required a data-driven strategy to move away from mass marketing and focus efforts on customer segments with the highest conversion potential and lifetime value (LTV).
By implementing the RFM (Recency, Frequency, Monetary) framework, this analysis identifies high-value customer groups, flags segments at risk of churning, and provides actionable insights to drive personalized, cost-effective marketing strategies.

### 2. Tech Stack & Project Structure
   
Database / Data Transformation: MySQL (Window Functions, CTEs)
Data Visualization: Power BI (In progress)

Repository Structure:
data/regional_sales_data.csv – Raw, historical sales dataset.
scripts/customers_segmentation.sql – Production-ready SQL script containing data aggregation, scoring (NTILE), and customer segmentation logic.
dashboards/customers_segmentation.pbix – Interactive Power BI dashboard visualizing segment distribution and KPIs.

### 3. Step-by-Step Methodology
   
Data Understanding & Revenue Formula Calibration:
Before writing the query, I analyzed the schema to properly calculate net revenue. Since Discount Applied was stored as a percentage/decimal, I formulated the logic to calculate the actual price paid per line item:
Order Quantity * Unit Price * (1 - Discount Applied).

RFM Metrics Extraction (SQL Agregation):
I aggregated the raw transactional data by CustomerID using SQL group functions:
Recency: Calculated using DATEDIFF between the snapshot date ('2020-12-31') and the maximum order date (MAX(OrderDate)) per customer.
Frequency: Captured via COUNT(DISTINCT OrderNumber) to count unique buying events.
Monetary: Computed using the calibrated revenue formula inside a SUM() function.

Customer Scoring via Window Functions (NTILE):
To divide the customer base into 5 equal tiers for each metric, I implemented the NTILE(5) window function. I carefully calibrated the sorting logic (ASC vs DESC) to ensure that the best performing customers (lowest recency, highest frequency, highest monetary) consistently received a score of 5, while the lowest received a 1.

Modular Code Architecture (CTEs):
To ensure clean, readable, and maintainable code, I structured the script using multiple Common Table Expressions (CTEs). This allowed me to bypass SQL's execution order limitations and cleanly concatenate the scores into a single rfm_score string.

Business Segmentation Logic:
I applied a comprehensive CASE WHEN statement to translate numerical RFM combinations into meaningful business personas (e.g., Champions, At Risk, Hibernating), prioritizing high-risk/high-reward segments first to avoid logical overlaps.

### 4. Business Insights & Actionable Recommendations
   
🚨 "At Risk" Segment (High History, Low Recency)
Insight: These are historically loyal, high-spending customers who haven't made a purchase recently. They represent a critical risk of customer churn, but possess high reactivation value.
Recommendation: Implement a targeted Win-Back Campaign. Send personalized emails with limited-time, high-incentive discount codes (e.g., "We miss you! Here is 20% off your next order"). Focus marketing communication on new arrivals that match their past purchase categories to trigger re-engagement.

🏆 "Champions" Segment (High Recency, High Frequency, High Monetary)
Insight: The company's most valuable asset. These customers buy frequently, recently, and spend the most. They do not need margin-eroding discounts to buy, as their brand loyalty is already high.
Recommendation: Enroll them into an exclusive VIP Loyalty Program. Instead of discounts, offer non-monetary value: early access to new product launches, dedicated premium customer support, or rewards based on points. Leverage this segment for referral marketing and brand advocacy.
