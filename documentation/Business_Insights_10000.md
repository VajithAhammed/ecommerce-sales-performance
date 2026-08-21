# Business Insights & Recommendations — 10,000-Row Scaled Dataset
### Source: synthetic 10,000-order dataset (Jan 1 – Dec 31, 2026), generated per `documentation/Scaling_Plan.md` and verified identically across `sql/ecommerce_10000.db`, `excel/Ecommerce_Sales_Analysis_10000.xlsx`, and `python/insights_output_10000.txt`

## Headline KPIs
| KPI | Value |
|---|---|
| Total Revenue | ₹9,70,78,858.70 (~₹9.71 Cr) |
| Total Profit | ₹2,11,82,258.04 (~₹2.12 Cr) |
| Overall Profit Margin | 21.82% |
| Total Orders | 10,000 (9,462 delivered, 538 cancelled) |
| Average Order Value | ₹10,259.87 |
| Unique Customers | 893 |
| Conversion Rate | 94.62% |
| Return Rate | 8.36% |

*(All figures cross-validated: SQL query output, Excel `KPI_Dashboard` formula
results, and Python's independently computed aggregates agree to the rupee.)*

## Insight 1 — Electronics still dominates, and its margin gap versus other categories narrows at scale
Electronics remains the top category by revenue (₹5.62 Cr, 58% of total) and
profit (₹1.23 Cr), but at 10,000 rows its margin (21.86%) is now **in line
with** Fashion (21.86%) and Home Appliances (21.79%) rather than being the
laggard seen in the 25-row prototype. Only Books (21.18%) and Sports (20.95%)
trail slightly. **This changes the prototype's Insight 1** — the "Electronics
has the worst margin" pattern was a small-sample artifact; at scale, margin is
fairly uniform (~21–22%) across categories, and Electronics is a strong
performer on both volume and profitability. **Recommendation:** Since margin
is now roughly flat across categories, prioritize category investment by
absolute profit contribution — Electronics (₹1.23 Cr) and Home Appliances
(₹45.65 L) — rather than chasing margin differences that are marginal at
this scale.

## Insight 2 — Returning customers are now overwhelmingly the revenue base
With realistic repeat-purchase structure (893 customers, 96% of whom placed
more than one order), Returning-customer orders account for 8,628 of 9,462
completed orders (91%) and ₹8.86 Cr of revenue (91%), versus New-customer
orders at ₹84.5 L (9%). This is a much clearer signal than the 25-row
prototype could show (where every customer was a one-time buyer by
construction). **Recommendation:** Retention is now demonstrably the primary
revenue driver — invest disproportionately in loyalty programs, re-engagement
email/SMS, and post-purchase experience, since acquiring net-new customers
contributes a small minority of revenue compared to keeping existing ones
buying.

## Insight 3 — South region confirmed as the commercial core, at a larger and more stable margin
South holds 4,096 of 9,462 orders (43%) and ₹4.16 Cr of revenue (43%), followed
by West (28%), North (16%), and East (13%). This mirrors the prototype's South
> West > North > East ordering, now on a base 400x larger — the regional
concentration pattern holds up at scale, giving more confidence it reflects a
real underlying pattern rather than sampling noise. **Recommendation:**
Confirmed — treat South as the primary market; East, while still smallest,
now has enough volume (1,290 orders, ₹1.24 Cr) to justify a real regional
marketing test rather than the token pilot suggested at prototype scale.

## Insight 4 — Evening peak-hour pattern confirmed and sharpened
19:00–21:00 accounts for 3,685 of 9,462 orders (39%) and ₹3.80 Cr of revenue
(39%) — the single busiest hour is 20:00 with 1,295 orders. This is the same
pattern seen in the 25-row prototype (37.5% concentration), now statistically
much more reliable. **Recommendation:** Confirmed — commit operational
resources (customer support staffing, flash-sale scheduling, ad delivery
windows) to the 19:00–21:00 window; this is a stable, high-confidence pattern.

## Insight 5 — Discount-vs-profit relationship confirmed: more discount, less profit per order
Average profit per order falls monotonically with discount band: Low
(0–6.9%) ₹2,650.46 → Medium (7–11.9%) ₹2,362.29 → High (12%+) ₹1,540.11.
The correlation coefficient is -0.096 (10,000-row sample), a small but now
statistically much more trustworthy negative relationship than the 25-row
prototype's -0.083. **Recommendation:** Confirmed at scale — blanket high
discounting is not paying for itself in per-order profit terms. Continue to
reserve discounts above 12% for clearance/inventory-specific use cases,
not as a default promotional lever.

## Insight 6 — Fashion's elevated return rate is confirmed, not a fluke
At scale, Fashion has a 14.68% return rate — roughly 2–2.7x every other
category (Furniture 7.69%, Electronics 6.08%, Books 6.07%, Sports 5.45%, Home
Appliances 5.36%). The 25-row prototype's "both returns were Fashion" signal
(n=2) is now backed by 274 actual Fashion returns out of 1,867 delivered
Fashion orders. **Recommendation:** This is now a high-confidence,
actionable finding — prioritize a size-guide/fit-accuracy and product-photo
audit specifically for the Fashion category; it is the one category with a
real, scale-confirmed quality/expectation-mismatch signal.

## Insight 7 — Conversion rate holds steady, funnel is not the primary leak
94.62% of the 10,000 sessions completed checkout (9,462 completed, 538
cancelled) — close to the prototype's 96%. With conversion consistently high
across both scales, the checkout funnel is not where revenue is being lost;
growth levers remain AOV and retention (Insight 2), consistent with the
prototype's conclusion.

## Insight 8 (new at scale) — Revenue and profit both trend upward through the year
Monthly revenue grows from ₹81.3 L in January to a peak of ₹1.03 Cr in
November, with a dip in February (₹61.0 L) — the lowest month, plausibly
tied to fewer calendar days. October–December (₹9.70 Cr, ₹10.28 Cr, ₹10.10 Cr)
are consistently the three strongest months. **Recommendation:** Plan
inventory and staffing for a Q4 demand ramp; investigate the February dip
to confirm whether it is purely a calendar effect (28 days) or a deeper
seasonal softness worth addressing with a targeted campaign.

---
*All figures above are computed directly from the 10,000-row dataset (SQL,
Excel, and Python independently agree) — none are assumed or invented. Where
this dataset's conclusions differ from the 25-row prototype (Insight 1), the
difference itself is a useful finding: it shows how a small sample can
mislead, and why validating patterns at scale matters before acting on them.*
