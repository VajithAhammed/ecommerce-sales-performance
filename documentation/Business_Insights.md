# Business Insights & Recommendations
### Source: 25-order prototype dataset (Jan 3–27, 2026), all figures verified against `sql/03_analysis_queries.sql`, the Excel `KPI_Dashboard`, and `python/insights_output.txt`

## Headline KPIs
| KPI | Value |
|---|---|
| Total Revenue | ₹95,477.75 |
| Total Profit | ₹23,877.75 |
| Overall Profit Margin | 25.01% |
| Total Orders | 25 (24 delivered, 1 cancelled) |
| Average Order Value | ₹3,978.24 |
| Total Customers | 25 (all unique in this sample) |
| Conversion Rate | 96.0% (24 of 25 sessions completed checkout) |
| Return Rate | 8.33% (2 of 24 delivered orders) |

## Insight 1 — Electronics drives revenue, but not the best margin
Electronics is the top category by both revenue (₹43,849.17, 46% of total) and
absolute profit (₹9,549.17), across 9 of 24 completed orders. However, its
profit margin (21.78%) is the **lowest** of all six categories — Sports
(41.46%) and Books (40.93%) are the most margin-efficient, even though they
contribute far less revenue (₹1,708 and ₹2,370 respectively).
**Recommendation:** Protect Electronics volume (it's the revenue engine) while
testing price/cost improvements on high-ticket electronics (Smartphone,
Monitor) to lift margin without sacrificing units.

## Insight 2 — Returning customers already out-spend new customers
Returning customers placed 13 of 24 orders (54%) and generated ₹53,110.04
(56% of revenue) at a higher AOV (₹4,085.39) than new customers (₹3,851.61,
11 orders, ₹42,367.71). The single highest lifetime-value customer in the
sample, however, is a **New** customer (CU014, ₹17,859.06 on one Smartphone
order).
**Recommendation:** Nurture first-time high-value buyers like CU014 with
early loyalty/retention outreach — they convert into the most valuable
segment (Returning) at above-average order sizes.

## Insight 3 — South region is the clear commercial center
South contributes 14 of 24 orders (58%) and ₹54,151.73 (57%) of revenue —
more than West, North, and East combined. East is a single order
(₹2,759.08) and represents the least-penetrated region in this sample.
**Recommendation:** Treat South as the core market for inventory/marketing
investment; treat East as an expansion opportunity worth a small, targeted
test campaign given the current near-zero footprint.

## Insight 4 — Evenings are peak shopping hours
Orders concentrate in the 19:00–21:00 window (9 of 24 orders, 37.5% of
volume, ₹32,768.93 combined revenue) — well above any other 3-hour block.
The single largest individual order (₹17,859.06, the Smartphone) happened
at 12:00, an outlier rather than the norm.
**Recommendation:** Schedule flash sales, push notifications, and customer
support staffing to align with the 19:00–21:00 peak window.

## Insight 5 — Higher discounts do not buy higher profit
Grouping orders into discount bands shows **average profit per order
falls** as discount rises: Low discount (0–6.9%) orders average
₹1,086.40 profit vs. ₹896.90 for High discount (12%+) orders — a -0.083
correlation between discount % and profit ₹ per order (essentially flat-to-
slightly-negative, not a driver of higher profit).
**Recommendation:** Avoid blanket high-discount promotions; discounting
isn't paying for itself in profit terms in this sample. Reserve deep
discounts for clearing specific slow-moving stock rather than as a default
lever.

## Insight 6 — Returns are concentrated in Fashion
Both returned orders in the sample (Backpack, T-Shirt — Return_Status =
"Yes") are Fashion category items, giving Fashion a 100% share of returns
despite being the #2 category by revenue.
**Recommendation:** Audit size/fit guidance and product photography for
Fashion listings specifically; this is the one category showing a
return-quality signal in the data (small sample — validate at scale).

## Insight 7 — Checkout conversion is strong; the funnel isn't the leak
96% of sessions in this sample completed checkout — only one order
(ORD1009, Keyboard) was cancelled. With conversion already high, revenue
growth is more likely to come from AOV and repeat-purchase levers (Insight
2) than from fixing checkout friction.

---
*All figures above are computed directly from the 25-row dataset — none are
assumed or invented. On the full 10,000+ row dataset (see
`documentation/Scaling_Plan.md`), the same SQL/Python/Power BI logic should
be re-run to confirm whether these directional patterns hold at scale.*
