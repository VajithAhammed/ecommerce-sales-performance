# Interview Preparation Kit

## Resume Project Description (ready to paste)

**E-Commerce Sales Performance Dashboard** | SQL, Advanced Excel, Python, Power BI
- Extracted and cleaned 10,000 raw e-commerce transactional records using SQL queries
  and Advanced Excel to ensure data accuracy, building a normalized star-schema
  (fact/dimension) database and a data-quality validation layer (duplicate,
  missing-value, and referential-integrity checks — 0 orphan keys, 0 duplicate
  order IDs at full scale).
- Designed an interactive Power BI dashboard utilizing DAX measures to track revenue
  growth, profit margins, and top-performing product categories across a 4-page
  report (Executive Overview, Product & Category, Customer Analytics, Sales &
  Operations) with synchronized slicers for date, region, category, and customer type.
- Delivered actionable business insights to highlight customer purchasing trends,
  conversion metrics, and peak sales hours — identifying a 94.6% checkout conversion
  rate, a 39% concentration of orders in the 7–9 PM window, a 91% revenue share from
  returning customers, and a Fashion-specific return-rate signal (14.7% vs. 5–8% for
  other categories) that informed targeted business recommendations.

---

## 21 SQL Interview Questions

1. Walk me through the schema you designed for this project — why fact/dimension tables instead of one flat table?
2. How did you calculate Revenue when Discount is stored as a fraction? Write the expression.
3. What's the difference between `WHERE` and `HAVING`, and where did you use each here?
4. Explain the `RANK()` window function you used for Top 10 Products — how does it differ from `ROW_NUMBER()` and `DENSE_RANK()`?
5. Why use a CTE for the Customer Analysis query instead of a subquery?
6. How would you compute Month-over-Month revenue growth in SQL using window functions?
7. What's the difference between `INNER JOIN` and `LEFT JOIN`, and which did you use to connect orders to customers/products — why?
8. How did you calculate Conversion Rate vs. Return Rate — what's the denominator for each, and why are they different?
9. Explain `SUMPRODUCT`-style running totals — how did you implement a cumulative revenue query?
10. How would you detect duplicate Order_IDs using pure SQL?
11. What indexes did you create, and why do `Order_Date`, `Customer_ID`, and `Product_ID` make sense as index candidates?
12. If Order_Completed = 0, should that row count toward Total Revenue? Why did you filter it out?
13. Write a query to find customers who placed more than one order (once the dataset scales beyond the current 1-order-per-customer prototype).
14. How would you handle a NULL in Discount when calculating Revenue?
15. Explain the CASE statement you used to bucket Discount into Low/Medium/High bands.
16. What's the difference between `COUNT(*)`, `COUNT(column)`, and `COUNT(DISTINCT column)` — where would each matter in this dataset?
17. How would you paginate a query returning all 10,000+ orders efficiently?
18. What's a covering index, and would one help the Peak Sales Hour query?
19. How would you migrate this schema from SQLite to PostgreSQL or SQL Server — what data types would you need to change?
20. This project originally modeled `Customer_Type` as a `dim_customers` attribute, then moved it to `fact_orders.Customer_Type_At_Order` once repeat customers appeared at scale — why was that the right fix, and how would you decide if an attribute belongs on a dimension vs. a fact table?

## 10 Excel Interview Questions

1. Why did you choose INDEX/MATCH over XLOOKUP for the Category lookup, given XLOOKUP is newer? (Compatibility across Excel versions/older files.)
2. Walk through your SUMIFS formula for Category revenue — what are the sum range and criteria range?
3. How does COUNTIFS differ from COUNTIF, and where did you need multiple criteria?
4. Explain the IFS() function you used for Customer_Segment — what would happen if none of the conditions matched?
5. How do you extract the hour from a text time value like "14:20" without a native TIME datatype?
6. What's the difference between a Pivot Table and the SUMIFS-based summary tables you built — when would you prefer each?
7. How do you build a Pivot Chart from a Pivot Table, and what's the benefit of linking them vs. a static chart?
8. What formula would you use to flag duplicate Order_IDs conditionally (e.g., conditional formatting)?
9. Why is it important to convert formula-driven cells to values (or leave them as formulas) before sharing a workbook — what's the trade-off?
10. How would you audit a large workbook for formula errors before delivering it? (Trace Precedents/Dependents, Error Checking, or a recalculation pass.)

## 10 Power BI / DAX Interview Questions

1. Explain the difference between a calculated column and a measure — where did you use each?
2. Walk through your `Total Revenue` measure — why `SUMX` instead of `SUM`?
3. What does `CALCULATE` do, and how did you use it for `Completed Orders` and `Return Rate %`?
4. Explain `DIVIDE()` vs. the `/` operator — why is `DIVIDE` safer for ratio measures like Conversion Rate?
5. What is `DATEADD` doing in your `Revenue (Prior Month)` measure, and why do you need a proper Date table for it to work?
6. Explain filter context vs. row context — why does `SUMX` need row context but `SUM` doesn't?
7. How does `ALLSELECTED` differ from `ALL` in your Running Total Revenue measure?
8. Why did you build a star schema instead of importing one flat table into Power BI?
9. How do slicers propagate filters across visuals, and what does "Sync Slicers" do across report pages?
10. How would `RANKX` behave differently if you used `ALL(dim_products[Product_Name])` vs. no `ALL` at all in the Top Product Rank measure?

## 10 Python Interview Questions

1. Why use `pandas.cut()` for the Discount Band and Age Group segments instead of a manual loop?
2. Walk through how you calculated Profit Margin % — how did you avoid a divide-by-zero error?
3. What's the difference between `.groupby().agg()` and `.pivot_table()` — could you have used either here?
4. How did you convert the "HH:MM" time string into an hour integer for the peak-hour analysis?
5. Why check `df.isnull().sum()` and `df.duplicated().sum()` before running any aggregation?
6. Explain the correlation coefficient you computed between Discount and Profit — what does a value near -0.08 tell you (and not tell you)?
7. What's the difference between `df[df['Order_Completed']==1]` and `df.query('Order_Completed == 1')` — is there a performance difference at scale?
8. How would matplotlib's `savefig` change if you needed the chart at print resolution vs. web resolution?
9. How would you scale this script to 10,000+ rows without changing the logic — what would you profile for performance?
10. Why did you separate "completed" orders from "all orders" in different aggregations (Conversion Rate uses all orders; Revenue uses only completed)?

## 20 Project-Specific Interview Questions

1. Why did you build a 25-row prototype before scaling to 10,000+ rows?
2. Walk me through your end-to-end pipeline from raw CSV to Power BI dashboard.
3. Which business insight from this project would you act on first if you were the store's category manager, and why?
4. You found Electronics has the highest revenue but the lowest margin — how would you validate this holds at 10,000+ rows before recommending a pricing change?
5. Why is Average Order Value calculated using only completed orders, not all orders?
6. How did you validate that your Excel formulas, SQL queries, and Python script all produce the same numbers?
7. What would you do differently if Return_Status data were missing for 30% of rows?
8. Why did you choose SQLite for the prototype instead of a heavier database like PostgreSQL?
9. How would you detect if your 10,000-row synthetic dataset is unrealistic compared to real transactional data?
10. What's the risk of drawing conclusions (like the Fashion-return signal) from only 2 data points, and how do you communicate that appropriately to stakeholders?
11. How would you turn this into a live, refreshing dashboard instead of a static snapshot?
12. What would you add to the schema if the company wanted to track marketing channel/campaign attribution?
13. How did you decide which 4 pages to include in the Power BI report, and what's the logic behind grouping visuals that way?
14. If conversion rate dropped from 96% to 80% next month, which tables/queries would you check first?
15. What's the single most actionable recommendation this project produced, and what data would you want next to strengthen it?
16. You changed `Customer_Type` from a customer-level attribute to an order-level one after scaling to 10,000 rows — walk me through how you noticed the bug and what the wrong numbers looked like before the fix.
17. At scale, Electronics' profit margin went from "worst category" (prototype) to "in line with everyone else" (10,000 rows) — how do you decide which of two conflicting results to trust?
18. Why did you generate the 10,000-row dataset with a customer pool and purchase-frequency weighting instead of just repeating random rows 400 times?
19. How did you verify your synthetic 10,000-row dataset was realistic rather than just large?
20. If your manager asked "can I trust the insights from the 25-row version," what would you tell them?
