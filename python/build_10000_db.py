"""
Builds sql/ecommerce_10000.db from data/ecommerce_data_10000.csv using the
SAME schema as the prototype (sql/01_schema.sql), loaded via pandas.to_sql
bulk insert (chunked) instead of hand-written INSERT statements — this is
the production-scale equivalent of sql/02_insert_data.sql.
"""
import pandas as pd
import sqlite3
import time

df = pd.read_csv("../data/ecommerce_data_10000.csv")

conn = sqlite3.connect("../sql/ecommerce_10000.db")
cur = conn.cursor()
cur.executescript(open("../sql/01_schema.sql").read())

t0 = time.time()

# dim_customers: demographic attributes only (no Customer_Type — see schema note)
cust = (df.sort_values("Order_Date")
          .drop_duplicates("Customer_ID")[["Customer_ID","Gender","Age","City","Region"]])
cust.to_sql("dim_customers", conn, if_exists="append", index=False, chunksize=1000)

# dim_products
prod = df[["Product_Name","Category"]].drop_duplicates().reset_index(drop=True)
prod.insert(0, "Product_ID", range(1, len(prod) + 1))
prod.to_sql("dim_products", conn, if_exists="append", index=False, chunksize=1000)

prod_map = {(r.Product_Name, r.Category): r.Product_ID for r in prod.itertuples()}
df["Product_ID"] = df.apply(lambda r: prod_map[(r.Product_Name, r.Category)], axis=1)
df["Customer_Type_At_Order"] = df["Customer_Type"]

fact = df[["Order_ID","Order_Date","Order_Time","Customer_ID","Product_ID","Quantity",
           "Unit_Price","Discount","Cost","Payment_Method","Order_Status",
           "Session_Duration","Pages_Viewed","Order_Completed","Shipping_Days","Return_Status",
           "Customer_Type_At_Order"]]
fact.to_sql("fact_orders", conn, if_exists="append", index=False, chunksize=1000)

conn.commit()
elapsed = time.time() - t0

print(f"Bulk load complete in {elapsed:.2f}s")
print("customers:", pd.read_sql("select count(*) from dim_customers", conn).iloc[0,0])
print("products:", pd.read_sql("select count(*) from dim_products", conn).iloc[0,0])
print("orders:", pd.read_sql("select count(*) from fact_orders", conn).iloc[0,0])

# integrity checks
orphan_cust = pd.read_sql("""
    SELECT COUNT(*) n FROM fact_orders f
    LEFT JOIN dim_customers c ON f.Customer_ID = c.Customer_ID
    WHERE c.Customer_ID IS NULL
""", conn).iloc[0,0]
orphan_prod = pd.read_sql("""
    SELECT COUNT(*) n FROM fact_orders f
    LEFT JOIN dim_products p ON f.Product_ID = p.Product_ID
    WHERE p.Product_ID IS NULL
""", conn).iloc[0,0]
dupes = pd.read_sql("SELECT COUNT(*) n FROM (SELECT Order_ID FROM fact_orders GROUP BY Order_ID HAVING COUNT(*)>1)", conn).iloc[0,0]
print(f"Orphan customer refs: {orphan_cust} | Orphan product refs: {orphan_prod} | Duplicate Order_IDs: {dupes}")

conn.execute("VACUUM")
conn.close()
