# 📊 Customer Segmentation Analysis using RFM & SQL

---

## 📌 1. Business Context

The objective of this project was to optimize marketing spend and maximize Campaign ROI for OmniWholesale Co. Facing strict budget constraints, the Marketing Director required a data-driven strategy to move away from mass marketing and focus efforts on customer segments with the highest conversion potential and lifetime value (LTV).

By implementing the **RFM (Recency, Frequency, Monetary)** framework, this analysis:
* Identifies high-value customer groups.
* Flags high-value accounts at risk of churning.
* Provides actionable insights to drive personalized, cost-effective marketing strategies.

---

## 🛠️ 2. Tech Stack & Repository Structure

* **Database / Data Transformation:** `MySQL` (Advanced Window Functions, CTEs)
* **Data Visualization:** `Power BI` *(In Progress)*

```text
├── data/
│   └── regional_sales_data.csv        # Raw, historical sales dataset
├── scripts/
│   └── customers_segmentation.sql     # Production-ready SQL script (Aggregation, Scoring, Segmentation)
└── dashboards/
    └── customers_segmentation.pbix    # Interactive Power BI dashboard
```

---

## 🧠 3. Step-by-Step Methodology

* **Data Understanding & Revenue Calibration**  
  * Analyzed schema to calculate net revenue accurately.  
  * Formulated line-item revenue logic considering decimal discounts:  
    `Order Quantity * Unit Price * (1 - Discount Applied)`

* **RFM Metrics Extraction (SQL Aggregation)**  
  * **Recency:** `DATEDIFF('2020-12-31', MAX(OrderDate))`  
  * **Frequency:** `COUNT(DISTINCT OrderNumber)`  
  * **Monetary:** `SUM(Net Revenue)`

* **Customer Scoring (`NTILE`)**  
  * Applied `NTILE(5)` window functions to partition customers into 5 equal tiers per metric.  
  * Calibrated sorting directions (`ASC` vs `DESC`) so top performers consistently receive a **5** score.

* **Modular Architecture (CTEs)**  
  * Structured the logic using multiple Common Table Expressions for readability and maintainability.  
  * Concatenated scores into a single `rfm_score` string.

* **Business Segmentation Logic**  
  * Built a prioritized `CASE WHEN` block to categorize clients into actionable business personas (*Champions*, *At Risk*, *Loyal Customers*, *Hibernating*).

---

## 💡 4. Business Insights & Recommendations

> ### 🚨 "At Risk" Segment (High History | Low Recency)
> * **Insight:** Historically loyal, high-spending accounts that haven't purchased recently. They represent high revenue potential but face immediate churn risk.  
> * **Action Plan:** Launch a targeted **Win-Back Campaign**. Send automated emails with time-sensitive, highly attractive offers (e.g., *"We miss you! Take 20% off your next order"*).

<br>

> ### 🏆 "Champions" Segment (High Recency | High Frequency | High Monetary)
> * **Insight:** The company's core revenue drivers. They buy frequently, recently, and spend the most. Brand loyalty is high, making margin-reducing discounts unnecessary.  
> * **Action Plan:** Enroll them into an exclusive **VIP Loyalty Program**. Provide non-monetary perks: early access to product launches, dedicated account management, and exclusive events.
