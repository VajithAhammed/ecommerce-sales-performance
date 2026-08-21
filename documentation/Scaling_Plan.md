# Scaling the Prototype: 25 Rows → 10,000+ Records

The entire architecture — schema, SQL queries, Excel formulas, Python script,
and Power BI model/DAX — was built to be **row-count agnostic**. Nothing
hardcodes "25"; every formula/query aggregates over a range or table, so
scaling is a data-volume change, not an architecture change.

## What changes
| Layer | Change needed |
|---|---|
| `data/` | Replace the 25-row CSV with a generated 10,000+ row CSV (same 21 columns, same dtypes) |
| SQL | None to the schema/query *logic*. Bulk-load via pandas `to_sql` instead of hand-written `INSERT`s (see below) |
| Excel | Extend named ranges / table ranges from row 26 to row 10,001 (Excel Tables auto-expand if the raw data is converted to a Table object first — done in `build_workbook_10000.py`) |
| Python | None — pandas operations already vectorized over the full DataFrame |
| Power BI | None — DAX measures use `SUM`/`SUMX`/`CALCULATE` over the table, not fixed ranges |

> **Update after actually scaling to 10,000 rows:** one schema correction was
> needed and has been applied to `sql/01_schema.sql` — `Customer_Type` (New/
> Returning) was originally modeled as a fixed `dim_customers` attribute. At
> 25 rows, every customer appeared exactly once, so this looked correct. At
> 10,000 rows, with real repeat customers, it became clear `Customer_Type` is
> a **transactional** attribute (a customer is "New" on their first order and
> "Returning" on every order after) — so it now lives on `fact_orders` as
> `Customer_Type_At_Order`, not on `dim_customers`. This is exactly the kind
   of design issue small prototypes can hide and scale testing reveals —
   both `sql/02_insert_data.sql` and `sql/03_analysis_queries.sql` (queries
   10 and 11) were updated accordingly, and both the 25-row and 10,000-row
   databases were rebuilt and re-validated against the corrected schema.

## What does NOT change
- Star-schema design (`dim_customers`, `dim_products`, `fact_orders`)
- Every KPI definition (Revenue, Profit, Margin, AOV, Conversion, Return Rate)
- Every DAX measure and every SQL query in `sql/03_analysis_queries.sql`
- The 4 Power BI report pages and their visuals
- The Excel workbook's 5-sheet structure

## Recommended generation approach for the 10,000+ row dataset
1. **Preserve realism, don't randomize blindly.** Sample categorical fields
   (City, Region, Category, Payment_Method) from the *same* value sets and
   *same relative frequencies* seen in the 25-row prototype, using
   `numpy.random.choice(values, p=observed_probabilities)`.
2. **Keep referential integrity.** Generate a pool of ~500–1,000 unique
   `Customer_ID`s and ~150–300 unique products (mapped to the existing
   category list) and sample orders against those pools — this naturally
   creates repeat customers/products, which the 25-row sample lacks (every
   customer there is currently a one-time buyer).
3. **Preserve realistic correlations**, not independent randomness:
   - `Cost` ≈ 60–75% of `Quantity × Unit_Price` (matches the prototype's ratio)
   - `Order_Completed` should be 1 for ~90–96% of rows (matches observed
     conversion), skewed by `Session_Duration`/`Pages_Viewed`
   - `Return_Status = Yes` should occur more often in Fashion (per Insight 6),
     at roughly an 8–10% overall rate
   - `Order_Time` should cluster in the evening (19:00–21:00), matching the
     observed peak-hour pattern
4. **Span a full year (or more)**, not one month, so Monthly Revenue/Profit
   trends and MoM growth DAX measures become meaningful.
5. Bulk-load via `pandas.DataFrame.to_sql('fact_orders', engine, if_exists='append', chunksize=1000)`
   instead of individual `INSERT` statements — this is what "extracted and
   cleaned 10,000+ raw transactional records using SQL" refers to on the
   resume: the *extraction/load pipeline* is the same pattern, run at volume.

## Validation checklist before trusting the 10,000-row results
- [x] Row count matches expected total (`SELECT COUNT(*) FROM fact_orders`) → 10,000 ✓
- [x] Zero orphan `Customer_ID`/`Product_ID` (LEFT JOIN … WHERE dim.id IS NULL returns 0 rows) → 0 orphans ✓
- [x] `Data_Quality` sheet in Excel shows 0 duplicate Order_IDs, 0 missing critical fields ✓
- [x] Recalculate Excel with `recalc.py` → 0 formula errors across 5,543 formulas ✓
- [x] Spot-check totals in Power BI-equivalent (Excel `KPI_Dashboard`) against SQL and Python → all three agree exactly (₹9,70,78,858.70 revenue, ₹2,11,82,258.04 profit, 94.62% conversion, 8.36% return rate) ✓

This checklist has been run end-to-end for the 10,000-row dataset included in
this project — see `documentation/Business_Insights_10000.md` for the
resulting analysis.
