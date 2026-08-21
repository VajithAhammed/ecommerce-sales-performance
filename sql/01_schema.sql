/* ============================================================
   E-COMMERCE SALES PERFORMANCE DASHBOARD
   File: 01_schema.sql
   Purpose: Star-schema style relational design
   Engine tested on: SQLite (portable to MySQL/PostgreSQL/SQL Server
                      with minor type changes noted in comments)
   ============================================================ */

DROP TABLE IF EXISTS fact_orders;
DROP TABLE IF EXISTS dim_customers;
DROP TABLE IF EXISTS dim_products;

/* ---------- DIMENSION: CUSTOMERS ---------- */
CREATE TABLE dim_customers (
    Customer_ID     VARCHAR(10) PRIMARY KEY,
    Gender          VARCHAR(10),
    Age             INT,
    City            VARCHAR(50),
    Region          VARCHAR(20)
    -- NOTE: Customer_Type (New/Returning) is intentionally NOT stored here.
    -- It changes per order (a customer is "New" on their first order and
    -- "Returning" thereafter), so it is a transactional attribute captured
    -- in fact_orders.Customer_Type_At_Order, not a stable dimension.
);

/* ---------- DIMENSION: PRODUCTS ---------- */
CREATE TABLE dim_products (
    Product_ID      INTEGER PRIMARY KEY AUTOINCREMENT,   -- SERIAL in Postgres / IDENTITY in SQL Server
    Product_Name    VARCHAR(100) NOT NULL,
    Category        VARCHAR(50) NOT NULL,
    UNIQUE(Product_Name, Category)
);

/* ---------- FACT: ORDERS (one row per order line) ---------- */
CREATE TABLE fact_orders (
    Order_ID          VARCHAR(10) PRIMARY KEY,
    Order_Date         DATE NOT NULL,
    Order_Time         TIME NOT NULL,
    Customer_ID        VARCHAR(10) NOT NULL,
    Product_ID          INT NOT NULL,
    Quantity            INT NOT NULL,
    Unit_Price          DECIMAL(10,2) NOT NULL,
    Discount            DECIMAL(4,2) NOT NULL,      -- stored as fraction, e.g. 0.05 = 5%
    Cost                DECIMAL(10,2) NOT NULL,      -- total cost of goods for the line
    Payment_Method       VARCHAR(20),
    Order_Status         VARCHAR(20),                 -- Delivered / Cancelled / Pending ...
    Session_Duration      DECIMAL(5,2),                -- minutes spent on site
    Pages_Viewed           INT,
    Order_Completed         TINYINT(1),                  -- 1 = completed checkout, 0 = abandoned/cancelled
    Shipping_Days             INT,
    Return_Status               VARCHAR(5),               -- Yes/No
    Customer_Type_At_Order        VARCHAR(20),              -- New/Returning AS OF THIS ORDER (transactional, not a fixed customer attribute)
    FOREIGN KEY (Customer_ID) REFERENCES dim_customers(Customer_ID),
    FOREIGN KEY (Product_ID)  REFERENCES dim_products(Product_ID)
);

CREATE INDEX idx_orders_date     ON fact_orders(Order_Date);
CREATE INDEX idx_orders_customer ON fact_orders(Customer_ID);
CREATE INDEX idx_orders_product  ON fact_orders(Product_ID);
