"""
E-Commerce Sales Performance Dashboard — Python Analysis
Covers: data cleaning, EDA, revenue/profit analysis, product analysis,
        customer analysis, regional analysis, peak-hour analysis,
        discount-vs-profit analysis, return analysis.
Outputs: charts saved to ../screenshots/, printed insights to console
         and python/insights_output.txt
"""
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import os

pd.set_option("display.width", 120)
plt.rcParams["font.size"] = 9
OUT_DIR = "../screenshots"
os.makedirs(OUT_DIR, exist_ok=True)
report_lines = []

def log(msg=""):
    print(msg)
    report_lines.append(str(msg))

# ------------------------------------------------------------------
# 1. LOAD & CLEAN
# ------------------------------------------------------------------
df = pd.read_csv("../data/ecommerce_data.csv")

log("="*70)
log("1. DATA CLEANING")
log("="*70)
log(f"Rows loaded: {len(df)}")
log(f"Duplicate Order_IDs: {df['Order_ID'].duplicated().sum()}")
log(f"Missing values per column:\n{df.isnull().sum()[df.isnull().sum() > 0]}")
log("No missing values found." if df.isnull().sum().sum() == 0 else "")

df["Order_Date"] = pd.to_datetime(df["Order_Date"])
df["Order_Hour"] = pd.to_datetime(df["Order_Time"], format="%H:%M").dt.hour
df["Order_Month"] = df["Order_Date"].dt.to_period("M").astype(str)
df["Revenue"] = df["Quantity"] * df["Unit_Price"] * (1 - df["Discount"])
df["Discount_Amount"] = df["Quantity"] * df["Unit_Price"] * df["Discount"]
df["Profit"] = df["Revenue"] - df["Cost"]
df["Profit_Margin_Pct"] = np.where(df["Revenue"] > 0, df["Profit"] / df["Revenue"] * 100, 0)
df["Customer_Segment"] = df["Customer_Type"]  # already New/Returning

# only completed orders count toward revenue/profit KPIs
completed = df[df["Order_Completed"] == 1].copy()

# ------------------------------------------------------------------
# 2. EDA — quick shape / dtypes / describe
# ------------------------------------------------------------------
log("\n" + "="*70)
log("2. EXPLORATORY DATA ANALYSIS")
log("="*70)
log(f"Shape: {df.shape}")
log(f"\nNumeric summary:\n{df[['Age','Quantity','Unit_Price','Discount','Revenue','Profit']].describe().round(2)}")

# ------------------------------------------------------------------
# 3. REVENUE & PROFIT ANALYSIS
# ------------------------------------------------------------------
log("\n" + "="*70)
log("3. REVENUE & PROFIT ANALYSIS")
log("="*70)
total_revenue = completed["Revenue"].sum()
total_profit = completed["Profit"].sum()
total_orders = len(df)
completed_orders = len(completed)
aov = total_revenue / completed_orders
margin = total_profit / total_revenue * 100

log(f"Total Revenue        : ₹{total_revenue:,.2f}")
log(f"Total Profit          : ₹{total_profit:,.2f}")
log(f"Overall Profit Margin  : {margin:.2f}%")
log(f"Total Orders (all)      : {total_orders}")
log(f"Completed Orders          : {completed_orders}")
log(f"Average Order Value        : ₹{aov:,.2f}")

monthly = completed.groupby("Order_Month").agg(Revenue=("Revenue","sum"), Profit=("Profit","sum")).round(2)
log(f"\nMonthly Revenue & Profit:\n{monthly}")

# Chart: daily revenue trend
daily = completed.groupby("Order_Date")["Revenue"].sum().sort_index()
plt.figure(figsize=(9,4.5))
plt.plot(daily.index, daily.values, marker="o", color="#1F4E78")
plt.fill_between(daily.index, daily.values, alpha=0.1, color="#1F4E78")
plt.title("Daily Revenue Trend — January 2026")
plt.xlabel("Date"); plt.ylabel("Revenue (₹)")
plt.xticks(rotation=45, ha="right")
plt.tight_layout()
plt.savefig(f"{OUT_DIR}/01_daily_revenue_trend.png", dpi=150)
plt.close()

# ------------------------------------------------------------------
# 4. PRODUCT ANALYSIS
# ------------------------------------------------------------------
log("\n" + "="*70)
log("4. PRODUCT & CATEGORY ANALYSIS")
log("="*70)
top_products = completed.groupby("Product_Name").agg(
    Units_Sold=("Quantity","sum"), Revenue=("Revenue","sum"), Profit=("Profit","sum")
).sort_values("Revenue", ascending=False).round(2)
log(f"Top products by revenue:\n{top_products.head(10)}")

cat_summary = completed.groupby("Category").agg(
    Orders=("Order_ID","count"), Revenue=("Revenue","sum"), Profit=("Profit","sum")
).sort_values("Revenue", ascending=False).round(2)
cat_summary["Margin_%"] = (cat_summary["Profit"]/cat_summary["Revenue"]*100).round(2)
log(f"\nCategory summary:\n{cat_summary}")

plt.figure(figsize=(8,4.5))
plt.barh(cat_summary.index[::-1], cat_summary["Revenue"][::-1], color="#2E75B6")
plt.title("Revenue by Category")
plt.xlabel("Revenue (₹)")
plt.tight_layout()
plt.savefig(f"{OUT_DIR}/02_revenue_by_category.png", dpi=150)
plt.close()

plt.figure(figsize=(6,6))
plt.pie(cat_summary["Margin_%"].clip(lower=0), labels=cat_summary.index,
        autopct="%1.1f%%", colors=plt.cm.Blues(np.linspace(0.4,0.9,len(cat_summary))))
plt.title("Profit Margin % Share by Category")
plt.tight_layout()
plt.savefig(f"{OUT_DIR}/03_margin_share_by_category.png", dpi=150)
plt.close()

# ------------------------------------------------------------------
# 5. CUSTOMER ANALYSIS
# ------------------------------------------------------------------
log("\n" + "="*70)
log("5. CUSTOMER ANALYSIS")
log("="*70)
seg_summary = completed.groupby("Customer_Segment").agg(
    Orders=("Order_ID","count"), Revenue=("Revenue","sum")
).round(2)
seg_summary["AOV"] = (seg_summary["Revenue"]/seg_summary["Orders"]).round(2)
log(f"New vs Returning:\n{seg_summary}")

age_bins = pd.cut(df["Age"], bins=[0,25,35,45,100], labels=["<=25","26-35","36-45","46+"])
age_summary = completed.assign(Age_Group=pd.cut(completed["Age"], bins=[0,25,35,45,100],
                                labels=["<=25","26-35","36-45","46+"])
                     ).groupby("Age_Group", observed=True)["Revenue"].sum().round(2)
log(f"\nRevenue by Age Group:\n{age_summary}")

plt.figure(figsize=(6,4.5))
plt.bar(seg_summary.index, seg_summary["Revenue"], color=["#70AD47","#1F4E78"])
plt.title("Revenue: New vs Returning Customers")
plt.ylabel("Revenue (₹)")
plt.tight_layout()
plt.savefig(f"{OUT_DIR}/04_new_vs_returning.png", dpi=150)
plt.close()

# ------------------------------------------------------------------
# 6. REGIONAL ANALYSIS
# ------------------------------------------------------------------
log("\n" + "="*70)
log("6. REGIONAL ANALYSIS")
log("="*70)
region_summary = completed.groupby("Region").agg(
    Orders=("Order_ID","count"), Revenue=("Revenue","sum"), Profit=("Profit","sum")
).sort_values("Revenue", ascending=False).round(2)
log(f"{region_summary}")

plt.figure(figsize=(7,4.5))
plt.bar(region_summary.index, region_summary["Revenue"], color="#264478")
plt.title("Revenue by Region")
plt.ylabel("Revenue (₹)")
plt.tight_layout()
plt.savefig(f"{OUT_DIR}/05_revenue_by_region.png", dpi=150)
plt.close()

# ------------------------------------------------------------------
# 7. PEAK HOUR ANALYSIS
# ------------------------------------------------------------------
log("\n" + "="*70)
log("7. PEAK SALES HOUR ANALYSIS")
log("="*70)
hour_summary = completed.groupby("Order_Hour").agg(
    Orders=("Order_ID","count"), Revenue=("Revenue","sum")
).sort_index()
log(f"{hour_summary}")
peak_hour = hour_summary["Orders"].idxmax()
log(f"\nPeak order-volume hour: {peak_hour}:00 ({hour_summary['Orders'].max()} orders)")

plt.figure(figsize=(9,4.5))
plt.bar(hour_summary.index.astype(str), hour_summary["Orders"], color="#548235")
plt.title("Orders by Hour of Day")
plt.xlabel("Hour (24h)"); plt.ylabel("Number of Orders")
plt.tight_layout()
plt.savefig(f"{OUT_DIR}/06_orders_by_hour.png", dpi=150)
plt.close()

# ------------------------------------------------------------------
# 8. DISCOUNT vs PROFIT
# ------------------------------------------------------------------
log("\n" + "="*70)
log("8. DISCOUNT vs PROFIT ANALYSIS")
log("="*70)
bins = [0, 0.07, 0.12, 1]
labels = ["Low (0-6.9%)","Medium (7-11.9%)","High (12%+)"]
completed["Discount_Band"] = pd.cut(completed["Discount"], bins=bins, labels=labels, right=False)
disc_summary = completed.groupby("Discount_Band", observed=True).agg(
    Orders=("Order_ID","count"), Avg_Profit=("Profit","mean"), Total_Profit=("Profit","sum")
).round(2)
log(f"{disc_summary}")
corr = completed["Discount"].corr(completed["Profit"])
log(f"\nCorrelation (Discount % vs Profit ₹): {corr:.3f}")

plt.figure(figsize=(6,4.5))
plt.scatter(completed["Discount"]*100, completed["Profit"], color="#C00000", alpha=0.7)
z = np.polyfit(completed["Discount"], completed["Profit"], 1)
xline = np.linspace(completed["Discount"].min(), completed["Discount"].max(), 50)
plt.plot(xline*100, np.poly1d(z)(xline), linestyle="--", color="gray")
plt.title("Discount % vs Profit per Order")
plt.xlabel("Discount %"); plt.ylabel("Profit (₹)")
plt.tight_layout()
plt.savefig(f"{OUT_DIR}/07_discount_vs_profit.png", dpi=150)
plt.close()

# ------------------------------------------------------------------
# 9. RETURN & CONVERSION ANALYSIS
# ------------------------------------------------------------------
log("\n" + "="*70)
log("9. RETURN & CONVERSION ANALYSIS")
log("="*70)
return_rate = (completed["Return_Status"] == "Yes").mean() * 100
conversion_rate = df["Order_Completed"].mean() * 100
log(f"Return Rate: {return_rate:.2f}%  ({(completed['Return_Status']=='Yes').sum()} of {len(completed)} delivered orders)")
log(f"Conversion Rate: {conversion_rate:.2f}%  ({df['Order_Completed'].sum()} of {len(df)} sessions completed checkout)")

returned = completed[completed["Return_Status"] == "Yes"]
log(f"\nReturned orders detail:\n{returned[['Order_ID','Product_Name','Category','Revenue']]}")

# ------------------------------------------------------------------
# SAVE TEXT REPORT
# ------------------------------------------------------------------
with open("insights_output.txt", "w", encoding="utf-8") as f:
    f.write("\n".join(report_lines))

# save enriched dataset for downstream Power BI / reference
df.to_csv("../data/ecommerce_data_enriched.csv", index=False)

print("\nAll charts saved to:", OUT_DIR)
print("Text report saved to: python/insights_output.txt")
print("Enriched dataset saved to: data/ecommerce_data_enriched.csv")
