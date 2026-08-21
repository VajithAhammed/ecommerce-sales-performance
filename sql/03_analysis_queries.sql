/* ============================================================
   File: 03_analysis_queries.sql
   Purpose: Business KPI & analytical queries
   Notes  : Revenue = Quantity * Unit_Price * (1 - Discount)
            Profit  = Revenue - Cost
            All queries validated against sql/ecommerce.db (SQLite)
   ============================================================ */

-- 1. TOTAL REVENUE (delivered/completed orders only)
SELECT
    ROUND(SUM(Quantity * Unit_Price * (1 - Discount)), 2) AS Total_Revenue
FROM fact_orders
WHERE Order_Completed = 1;

-- 2. TOTAL PROFIT
SELECT
    ROUND(SUM(Quantity * Unit_Price * (1 - Discount) - Cost), 2) AS Total_Profit
FROM fact_orders
WHERE Order_Completed = 1;

-- 3. TOTAL ORDERS (all orders placed, incl. cancelled)
SELECT COUNT(*) AS Total_Orders FROM fact_orders;

-- 3b. Completed vs Cancelled split
SELECT Order_Status, COUNT(*) AS Orders
FROM fact_orders
GROUP BY Order_Status;

-- 4. AVERAGE ORDER VALUE (AOV) — completed orders
SELECT
    ROUND(SUM(Quantity * Unit_Price * (1 - Discount)) * 1.0 / COUNT(*), 2) AS Avg_Order_Value
FROM fact_orders
WHERE Order_Completed = 1;

-- 5. MONTHLY REVENUE
SELECT
    strftime('%Y-%m', Order_Date) AS Order_Month,
    ROUND(SUM(Quantity * Unit_Price * (1 - Discount)), 2) AS Monthly_Revenue
FROM fact_orders
WHERE Order_Completed = 1
GROUP BY strftime('%Y-%m', Order_Date)
ORDER BY Order_Month;

-- 6. MONTHLY PROFIT
SELECT
    strftime('%Y-%m', Order_Date) AS Order_Month,
    ROUND(SUM(Quantity * Unit_Price * (1 - Discount) - Cost), 2) AS Monthly_Profit
FROM fact_orders
WHERE Order_Completed = 1
GROUP BY strftime('%Y-%m', Order_Date)
ORDER BY Order_Month;

-- 7. TOP 10 PRODUCTS BY REVENUE (window function for rank)
WITH product_revenue AS (
    SELECT
        p.Product_Name,
        p.Category,
        SUM(f.Quantity) AS Units_Sold,
        ROUND(SUM(f.Quantity * f.Unit_Price * (1 - f.Discount)), 2) AS Revenue
    FROM fact_orders f
    JOIN dim_products p ON f.Product_ID = p.Product_ID
    WHERE f.Order_Completed = 1
    GROUP BY p.Product_Name, p.Category
)
SELECT
    Product_Name, Category, Units_Sold, Revenue,
    RANK() OVER (ORDER BY Revenue DESC) AS Revenue_Rank
FROM product_revenue
ORDER BY Revenue DESC
LIMIT 10;

-- 8. TOP CATEGORIES BY REVENUE & PROFIT
SELECT
    p.Category,
    ROUND(SUM(f.Quantity * f.Unit_Price * (1 - f.Discount)), 2) AS Revenue,
    ROUND(SUM(f.Quantity * f.Unit_Price * (1 - f.Discount) - f.Cost), 2) AS Profit,
    COUNT(*) AS Orders
FROM fact_orders f
JOIN dim_products p ON f.Product_ID = p.Product_ID
WHERE f.Order_Completed = 1
GROUP BY p.Category
ORDER BY Revenue DESC;

-- 9. REGION-WISE SALES
SELECT
    c.Region,
    COUNT(*) AS Orders,
    ROUND(SUM(f.Quantity * f.Unit_Price * (1 - f.Discount)), 2) AS Revenue,
    ROUND(SUM(f.Quantity * f.Unit_Price * (1 - f.Discount) - f.Cost), 2) AS Profit
FROM fact_orders f
JOIN dim_customers c ON f.Customer_ID = c.Customer_ID
WHERE f.Order_Completed = 1
GROUP BY c.Region
ORDER BY Revenue DESC;

-- 10. CUSTOMER ANALYSIS (lifetime value per customer, using CTE + window fn)
WITH customer_orders AS (
    SELECT
        c.Customer_ID, c.City, c.Region,
        COUNT(f.Order_ID) AS Orders_Placed,
        ROUND(SUM(f.Quantity * f.Unit_Price * (1 - f.Discount)), 2) AS Lifetime_Revenue
    FROM dim_customers c
    JOIN fact_orders f ON c.Customer_ID = f.Customer_ID
    WHERE f.Order_Completed = 1
    GROUP BY c.Customer_ID, c.City, c.Region
)
SELECT *,
    RANK() OVER (ORDER BY Lifetime_Revenue DESC) AS Customer_Value_Rank
FROM customer_orders
ORDER BY Lifetime_Revenue DESC;

-- 11. NEW VS RETURNING CUSTOMERS — order count, revenue, AOV
-- Uses Customer_Type_At_Order (transactional: New on first order, Returning after)
SELECT
    f.Customer_Type_At_Order,
    COUNT(f.Order_ID) AS Orders,
    ROUND(SUM(f.Quantity * f.Unit_Price * (1 - f.Discount)), 2) AS Revenue,
    ROUND(AVG(f.Quantity * f.Unit_Price * (1 - f.Discount)), 2) AS Avg_Order_Value
FROM fact_orders f
WHERE f.Order_Completed = 1
GROUP BY f.Customer_Type_At_Order;

-- 12. PEAK SALES HOURS
SELECT
    CAST(strftime('%H', Order_Time) AS INT) AS Order_Hour,
    COUNT(*) AS Orders,
    ROUND(SUM(Quantity * Unit_Price * (1 - Discount)), 2) AS Revenue
FROM fact_orders
WHERE Order_Completed = 1
GROUP BY Order_Hour
ORDER BY Orders DESC, Order_Hour;

-- 13. DISCOUNT VS PROFIT (CASE-bucketed discount bands)
SELECT
    CASE
        WHEN Discount < 0.07 THEN 'Low (0-6.9%)'
        WHEN Discount < 0.12 THEN 'Medium (7-11.9%)'
        ELSE 'High (12%+)'
    END AS Discount_Band,
    COUNT(*) AS Orders,
    ROUND(SUM(Quantity * Unit_Price * (1 - Discount) - Cost), 2) AS Total_Profit,
    ROUND(AVG(Quantity * Unit_Price * (1 - Discount) - Cost), 2) AS Avg_Profit_Per_Order
FROM fact_orders
WHERE Order_Completed = 1
GROUP BY Discount_Band
ORDER BY Avg_Profit_Per_Order DESC;

-- 14. RETURN RATE (% of delivered orders that were returned)
SELECT
    ROUND(100.0 * SUM(CASE WHEN Return_Status = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS Return_Rate_Pct
FROM fact_orders
WHERE Order_Completed = 1;

-- 15. CONVERSION RATE (completed orders / total sessions i.e. all rows)
SELECT
    ROUND(100.0 * SUM(Order_Completed) / COUNT(*), 2) AS Conversion_Rate_Pct
FROM fact_orders;

-- 16. CATEGORY PROFIT MARGIN (%)
SELECT
    p.Category,
    ROUND(SUM(f.Quantity * f.Unit_Price * (1 - f.Discount)), 2) AS Revenue,
    ROUND(SUM(f.Quantity * f.Unit_Price * (1 - f.Discount) - f.Cost), 2) AS Profit,
    ROUND(100.0 * SUM(f.Quantity * f.Unit_Price * (1 - f.Discount) - f.Cost)
          / SUM(f.Quantity * f.Unit_Price * (1 - f.Discount)), 2) AS Profit_Margin_Pct
FROM fact_orders f
JOIN dim_products p ON f.Product_ID = p.Product_ID
WHERE f.Order_Completed = 1
GROUP BY p.Category
ORDER BY Profit_Margin_Pct DESC;

-- 17. BONUS: Running (cumulative) revenue by date — window function demo
SELECT
    Order_Date,
    ROUND(SUM(Quantity * Unit_Price * (1 - Discount)), 2) AS Daily_Revenue,
    ROUND(SUM(SUM(Quantity * Unit_Price * (1 - Discount))) OVER (ORDER BY Order_Date), 2) AS Running_Revenue
FROM fact_orders
WHERE Order_Completed = 1
GROUP BY Order_Date
ORDER BY Order_Date;
