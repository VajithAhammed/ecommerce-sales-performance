# Power BI Dashboard — Build Guide

> **Note on deliverables:** Power BI's `.pbix` is a binary format that only Power BI
> Desktop can produce/open — it cannot be generated from a script in this environment.
> What's provided instead is everything needed to build the exact dashboard in
> Power BI Desktop in under 20 minutes: the data model, every DAX measure
> (`DAX_Measures.txt`), and the full page-by-page layout below. Import
> `data/ecommerce_data_10000_enriched.csv` (or `sql/ecommerce_10000.db`) as the
> source for the full-scale build; `data/ecommerce_data_enriched.csv` /
> `sql/ecommerce.db` work identically for the 25-row prototype — no model or
> DAX changes needed either way.

## 1. Data Model

```
dim_customers (893 rows)         dim_products (41 rows)
  Customer_ID (PK)  ─┐              Product_ID (PK) ─┐
  Gender              │              Product_Name     │
  Age                 │              Category         │
  City                │                                │
  Region               │                               │
                       │                                │
                       ▼                                ▼
                  fact_orders (10,000 rows, 1 row = 1 order line)
                  Order_ID, Order_Date, Order_Time, Customer_ID (FK),
                  Product_ID (FK), Quantity, Unit_Price, Discount, Cost,
                  Payment_Method, Order_Status, Session_Duration,
                  Pages_Viewed, Order_Completed, Shipping_Days,
                  Return_Status, Customer_Type_At_Order

                       ▲
                       │  (1:*)
                  Date (calendar table, marked as Date Table)
                  Date, Year, Month, MonthName, Day, Hour
```

Relationships: `dim_customers[Customer_ID]` 1→* `fact_orders[Customer_ID]`;
`dim_products[Product_ID]` 1→* `fact_orders[Product_ID]`;
`Date[Date]` 1→* `fact_orders[Order_Date]`. All single-direction, star schema.

> **Note:** `Customer_Type_At_Order` (New/Returning) lives on `fact_orders`,
> not `dim_customers` — it's a transactional attribute (a customer is "New"
> on their first order and "Returning" on every order after), not a fixed
> customer property. See `documentation/Scaling_Plan.md` for why this
> mattered once real repeat customers existed at 10,000-row scale.

## 2. KPI Cards (place on every page's header strip)

| Card | Measure | Format |
|---|---|---|
| Total Revenue | `[Total Revenue]` | ₹9,70,78,858.70 |
| Total Profit | `[Total Profit]` | ₹2,11,82,258.04 |
| Profit Margin % | `[Profit Margin %]` | 21.8% |
| Total Orders | `[Total Orders]` | 10,000 |
| Total Customers | `[Total Customers]` | 893 |
| Average Order Value | `[Average Order Value]` | ₹10,259.87 |
| Conversion Rate % | `[Conversion Rate %]` | 94.6% |
| Return Rate % | `[Return Rate %]` | 8.4% |

(Values shown are the actual results from the 10,000-row dataset — see
`documentation/Business_Insights_10000.md`.)

## 3. Slicers (global, synced across all 4 pages via "Sync Slicers")

- **Date** — between slicer on `Date[Date]`
- **Region** — dropdown on `dim_customers[Region]`
- **Category** — dropdown on `dim_products[Category]`
- **Customer Type** — buttons on `dim_customers[Customer_Type]`
- **Payment Method** — dropdown on `fact_orders[Payment_Method]`
- **Order Status** — buttons on `fact_orders[Order_Status]`

## 4. Pages

### PAGE 1 — Executive Overview
- KPI card strip (all 8 cards above)
- Line chart: `Total Revenue` & `Total Profit` by `Order_Date` (dual axis)
- Column chart: `Total Revenue` by `Region`
- Donut chart: `Completed Orders` by `Order_Status`
- Card: `Revenue MoM Growth %`

### PAGE 2 — Product & Category Analysis
- Bar chart (horizontal): Top 10 products by `Total Revenue`, sorted desc
- Matrix: `Category` × `Total Revenue`, `Total Profit`, `Category Profit Margin %`
- Treemap: `Total Revenue` by `Category` → `Product_Name`
- Scatter: `Quantity` (x) vs `Avg Profit per Order` (y), bubble size = `Total Revenue`, split by `Category`

### PAGE 3 — Customer Analytics
- Card pair: `New Customer Revenue` vs `Returning Customer Revenue`
- Stacked bar: Orders by `Customer_Type` and `Region`
- Table: Customer-level `Total Revenue`, `Total Orders`, ranked (`Top Product Rank`-style RANKX)
- Donut: `Repeat Customer Rate %`
- Bar: Revenue by Age Group (calculated column bucketing `Age` into bands)

### PAGE 4 — Sales & Operations
- Column chart: `Completed Orders` by `Order_Hour` (peak-hour analysis)
- Scatter: `Discount Band` (x-axis category) vs `Avg Profit per Order` (y)
- KPI cards: `Avg Shipping Days`, `Avg Session Duration (min)`, `Avg Pages Viewed`
- Bar: `Return Rate %` by `Category`
- Table: Payment Method mix — Orders, Revenue, AOV

## 5. Suggested Theme
Primary `#1F4E78` (navy), Accent `#2E75B6` (blue), Positive `#548235` (green),
Negative `#C00000` (red), Neutral background `#F7F9FB`. Matches the Excel workbook
and Python chart palette for visual consistency across all three artifacts.

## 6. Step-by-Step Build
1. Power BI Desktop → Get Data → Text/CSV → `data/ecommerce_data_10000_enriched.csv`
   (or ODBC/SQLite connector → `sql/ecommerce_10000.db`).
2. Power Query: split into `dim_customers`, `dim_products`, `fact_orders` using
   Reference queries + Remove Duplicates + Remove Other Columns (mirrors
   `sql/01_schema.sql` / `02_insert_data.sql` logic).
3. Model view → create the 3 relationships shown above.
4. New Table → Date = `CALENDAR(MIN(fact_orders[Order_Date]), MAX(fact_orders[Order_Date]))`,
   mark as Date Table.
5. Home → New Measure → paste each block from `DAX_Measures.txt`.
6. Build the 4 report pages per the layouts above; add slicers; enable
   "Sync Slicers" (View ribbon) across pages.
7. File → Save As → `Ecommerce_Sales_Dashboard.pbix`.
