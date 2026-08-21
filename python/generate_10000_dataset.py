"""
Generates data/ecommerce_data_10000.csv — a realistic 10,000-row transactional
dataset that preserves the distributions, correlations, and business patterns
observed in the 25-row prototype (see documentation/Scaling_Plan.md), while
adding proper repeat-customer / repeat-product structure the prototype lacked.

Design choices (all traceable to the prototype or stated explicitly):
  - City/Region mix matches prototype's relative frequencies
  - Category mix matches prototype's relative frequencies
  - Payment_Method mix matches prototype's relative frequencies
  - Cost = 65-75% of (Quantity * Unit_Price), matching prototype's ~65-84% range
  - Order_Completed = 1 for ~96% of rows (matches prototype's 24/25)
  - Return_Status = "Yes" skewed toward Fashion (~14%) vs other categories (~6%),
    landing on an overall ~8% rate (matches prototype's 8.33%)
  - Order_Time clustered in the evening (19:00-21:00), matching prototype's peak
  - Date range spans a full year (2026-01-01 to 2026-12-31) so monthly trend
    and MoM DAX/SQL measures are meaningful
  - Customer pool: 900 unique customers -> creates real repeat purchasers
  - Product pool: 45 unique SKUs across the same 6 categories
"""
import numpy as np
import pandas as pd

rng = np.random.default_rng(42)
N = 10000

# ---------------------------------------------------------------
# Reference pools (extends the prototype's real product/city names)
# ---------------------------------------------------------------
CITY_REGION = {
    "Chennai": "South", "Bangalore": "South", "Hyderabad": "South",
    "Coimbatore": "South", "Kochi": "South", "Madurai": "South",
    "Mumbai": "West", "Pune": "West", "Ahmedabad": "West", "Nagpur": "West",
    "Delhi": "North", "Jaipur": "North", "Lucknow": "North", "Chandigarh": "North",
    "Kolkata": "East", "Bhubaneswar": "East", "Patna": "East", "Guwahati": "East",
}
# relative weights matching prototype (South heaviest, East lightest)
CITY_WEIGHTS = {
    "Chennai": 9, "Bangalore": 8, "Hyderabad": 7, "Coimbatore": 5, "Kochi": 5, "Madurai": 3,
    "Mumbai": 8, "Pune": 7, "Ahmedabad": 4, "Nagpur": 3,
    "Delhi": 7, "Jaipur": 4, "Lucknow": 3, "Chandigarh": 2,
    "Kolkata": 5, "Bhubaneswar": 3, "Patna": 2, "Guwahati": 2,
}
cities = list(CITY_WEIGHTS.keys())
city_p = np.array(list(CITY_WEIGHTS.values()), dtype=float)
city_p /= city_p.sum()

PRODUCTS = {
    "Electronics": [
        ("Wireless Mouse", 799), ("Smart Watch", 3999), ("Bluetooth Speaker", 1299),
        ("Keyboard", 1799), ("Monitor", 8999), ("Smartphone", 18999), ("Power Bank", 1599),
        ("Headphones", 2499), ("USB Cable", 499), ("Laptop Stand", 1999),
        ("Laptop", 42999), ("Earbuds", 2999),
    ],
    "Fashion": [
        ("Running Shoes", 2499), ("Backpack", 1499), ("Jeans", 1899), ("Handbag", 2799),
        ("T-Shirt", 799), ("Formal Shoes", 2999), ("Dress", 2199), ("Jacket", 3499),
        ("Sunglasses", 1299), ("Belt", 699),
    ],
    "Home Appliances": [
        ("Coffee Maker", 3299), ("Air Fryer", 5499), ("Table Lamp", 1199),
        ("Electric Kettle", 1799), ("Air Purifier", 7999), ("Mixer Grinder", 3999),
        ("Vacuum Cleaner", 6499), ("Microwave Oven", 8499),
    ],
    "Furniture": [
        ("Office Chair", 6999), ("Bookshelf", 4499), ("Study Table", 5999), ("Bed Frame", 12999),
    ],
    "Sports": [
        ("Yoga Mat", 899), ("Dumbbells Set", 2499), ("Cricket Bat", 1999), ("Football", 799),
    ],
    "Books": [
        ("Fiction Bundle", 499), ("Self-Help Book", 399), ("Textbook Set", 1499),
    ],
}
CATEGORY_WEIGHTS = {"Electronics": 40, "Fashion": 28, "Home Appliances": 20,
                    "Furniture": 4, "Sports": 4, "Books": 4}
categories = list(CATEGORY_WEIGHTS.keys())
cat_p = np.array(list(CATEGORY_WEIGHTS.values()), dtype=float)
cat_p /= cat_p.sum()

PAYMENT_WEIGHTS = {"UPI": 48, "Card": 44, "Net Banking": 8}
payments = list(PAYMENT_WEIGHTS.keys())
pay_p = np.array(list(PAYMENT_WEIGHTS.values()), dtype=float)
pay_p /= pay_p.sum()

# ---------------------------------------------------------------
# Customer pool (900 customers -> repeat purchases occur naturally)
# ---------------------------------------------------------------
N_CUSTOMERS = 900
customer_ids = [f"CU{str(i).zfill(5)}" for i in range(1, N_CUSTOMERS + 1)]
cust_city = rng.choice(cities, size=N_CUSTOMERS, p=city_p)
cust_gender = rng.choice(["Male", "Female"], size=N_CUSTOMERS, p=[0.52, 0.48])
cust_age = rng.integers(20, 55, size=N_CUSTOMERS)
# first-seen customer type snapshot decided later from order sequence

customers_df = pd.DataFrame({
    "Customer_ID": customer_ids,
    "Gender": cust_gender,
    "Age": cust_age,
    "City": cust_city,
    "Region": [CITY_REGION[c] for c in cust_city],
})

# Purchase-frequency weight per customer (power-law-ish: most buy once/twice, some buy often)
cust_weight = rng.pareto(2.2, size=N_CUSTOMERS) + 0.3
cust_weight /= cust_weight.sum()

# ---------------------------------------------------------------
# Generate orders
# ---------------------------------------------------------------
order_customer_idx = rng.choice(N_CUSTOMERS, size=N, p=cust_weight)
order_category = rng.choice(categories, size=N, p=cat_p)

product_name = np.empty(N, dtype=object)
unit_price = np.empty(N, dtype=float)
for cat in categories:
    mask = order_category == cat
    n_cat = mask.sum()
    options = PRODUCTS[cat]
    idx = rng.integers(0, len(options), size=n_cat)
    product_name[mask] = [options[i][0] for i in idx]
    base_price = np.array([options[i][1] for i in idx], dtype=float)
    # +/- 5% natural price variation (seasonal/SKU variant pricing)
    unit_price[mask] = np.round(base_price * rng.uniform(0.95, 1.05, size=n_cat), -1)

quantity = rng.choice([1, 1, 1, 2, 2, 3, 4, 5], size=N)  # skewed toward 1
discount = np.round(rng.choice([0.03, 0.05, 0.07, 0.08, 0.10, 0.12, 0.15, 0.18],
                                size=N, p=[0.12, 0.18, 0.14, 0.14, 0.16, 0.12, 0.09, 0.05]), 2)
cost_ratio = rng.uniform(0.65, 0.78, size=N)
cost = np.round(quantity * unit_price * cost_ratio, 2)

# dates across full year, slightly higher volume in Oct-Dec (festive season proxy) and low in Feb
month_weights = np.array([9, 7, 8, 8, 9, 8, 8, 9, 9, 11, 12, 12], dtype=float)
month_weights /= month_weights.sum()
months = rng.choice(np.arange(1, 13), size=N, p=month_weights)
days_in_month = {1:31,2:28,3:31,4:30,5:31,6:30,7:31,8:31,9:30,10:31,11:30,12:31}
days = np.array([rng.integers(1, days_in_month[m] + 1) for m in months])
order_dates = pd.to_datetime({"year": 2026, "month": months, "day": days})

# order times clustered 19:00-21:00, with a secondary lunchtime bump
hour_choices = list(range(9, 23))
hour_weights = np.array([2,3,4,4,3,4,5,6,5,4,9,10,9,3,2], dtype=float)
hour_weights = hour_weights[:len(hour_choices)]
hour_weights /= hour_weights.sum()
order_hour = rng.choice(hour_choices, size=N, p=hour_weights)
order_minute = rng.integers(0, 60, size=N)
order_time = [f"{h:02d}:{m:02d}" for h, m in zip(order_hour, order_minute)]

payment_method = rng.choice(payments, size=N, p=pay_p)

# session behavior: correlated with pages viewed / duration, mildly with completion
session_duration = np.round(rng.gamma(shape=3.0, scale=4.0, size=N) + 3, 1)
pages_viewed = np.clip((session_duration * rng.uniform(0.55, 0.75, size=N)).round().astype(int), 2, None)

# completion probability rises with session duration/pages, matching prototype's ~96% overall
base_p_complete = 0.90
completion_boost = np.clip((session_duration - 8) / 40, -0.05, 0.06)
p_complete = np.clip(base_p_complete + completion_boost, 0.80, 0.985)
order_completed = (rng.random(N) < p_complete).astype(int)

order_status = np.where(order_completed == 1, "Delivered", "Cancelled")
shipping_days = np.where(order_completed == 1, rng.integers(2, 8, size=N), 0)

# returns: skewed to Fashion (~14%) vs others (~6%), only possible on completed orders
return_prob = np.where(order_category == "Fashion", 0.14, 0.06)
return_status = np.where(
    (order_completed == 1) & (rng.random(N) < return_prob), "Yes", "No"
)

order_ids = [f"ORD{100000+i}" for i in range(N)]

df = pd.DataFrame({
    "Order_ID": order_ids,
    "Order_Date": order_dates.dt.strftime("%Y-%m-%d"),
    "Order_Time": order_time,
    "Customer_ID": [customer_ids[i] for i in order_customer_idx],
    "Product_Name": product_name,
    "Category": order_category,
    "Quantity": quantity,
    "Unit_Price": unit_price,
    "Discount": discount,
    "Cost": cost,
    "Payment_Method": payment_method,
    "Order_Status": order_status,
    "Session_Duration": session_duration,
    "Pages_Viewed": pages_viewed,
    "Order_Completed": order_completed,
    "Shipping_Days": shipping_days,
    "Return_Status": return_status,
})

# join customer demographics
df = df.merge(customers_df, on="Customer_ID", how="left")
df = df[["Order_ID","Order_Date","Order_Time","Customer_ID","Gender","Age","City","Region",
         "Product_Name","Category","Quantity","Unit_Price","Discount","Cost","Payment_Method",
         "Order_Status","Session_Duration","Pages_Viewed","Order_Completed","Shipping_Days","Return_Status"]]

# ---------------------------------------------------------------
# Customer_Type: "New" on a customer's first order (by date), "Returning" after
# ---------------------------------------------------------------
df["Order_Date_dt"] = pd.to_datetime(df["Order_Date"])
df = df.sort_values(["Customer_ID", "Order_Date_dt", "Order_Time"]).reset_index(drop=True)
first_order = df.groupby("Customer_ID")["Order_Date_dt"].transform("min")
df["Customer_Type"] = np.where(df["Order_Date_dt"] == first_order, "New", "Returning")
# resolve ties (same-day multiple "first" orders) by keeping only the earliest row as New
dup_first = df[df["Order_Date_dt"] == first_order].duplicated(subset="Customer_ID", keep="first")
tie_idx = df[df["Order_Date_dt"] == first_order].index[dup_first]
df.loc[tie_idx, "Customer_Type"] = "Returning"

df = df.sort_values("Order_Date_dt").drop(columns="Order_Date_dt").reset_index(drop=True)
df["Order_ID"] = [f"ORD{100001+i}" for i in range(len(df))]  # re-sequence IDs after date sort

df.to_csv("../data/ecommerce_data_10000.csv", index=False)

print("Generated rows:", len(df))
print("Unique customers used:", df['Customer_ID'].nunique())
print("Unique products:", df['Product_Name'].nunique())
print("Date range:", df['Order_Date'].min(), "to", df['Order_Date'].max())
print("Completion rate:", df['Order_Completed'].mean().round(4))
print("Return rate (completed):", (df.loc[df.Order_Completed==1,'Return_Status']=='Yes').mean().round(4))
print(df.head(3).to_string())
