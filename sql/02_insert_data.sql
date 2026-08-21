/* ============================================================
   File: 02_insert_data.sql
   Purpose: Populate dim_customers, dim_products, fact_orders
   Generated from data/ecommerce_data.csv (25-row prototype)
   ============================================================ */

-- DIM_CUSTOMERS
INSERT INTO dim_customers (Customer_ID,Gender,Age,City,Region) VALUES ('CU001','Male',24,'Chennai','South');
INSERT INTO dim_customers (Customer_ID,Gender,Age,City,Region) VALUES ('CU002','Female',29,'Bangalore','South');
INSERT INTO dim_customers (Customer_ID,Gender,Age,City,Region) VALUES ('CU003','Male',34,'Hyderabad','South');
INSERT INTO dim_customers (Customer_ID,Gender,Age,City,Region) VALUES ('CU004','Female',26,'Mumbai','West');
INSERT INTO dim_customers (Customer_ID,Gender,Age,City,Region) VALUES ('CU005','Male',41,'Delhi','North');
INSERT INTO dim_customers (Customer_ID,Gender,Age,City,Region) VALUES ('CU006','Female',23,'Coimbatore','South');
INSERT INTO dim_customers (Customer_ID,Gender,Age,City,Region) VALUES ('CU007','Male',31,'Pune','West');
INSERT INTO dim_customers (Customer_ID,Gender,Age,City,Region) VALUES ('CU008','Female',37,'Kochi','South');
INSERT INTO dim_customers (Customer_ID,Gender,Age,City,Region) VALUES ('CU009','Male',28,'Kolkata','East');
INSERT INTO dim_customers (Customer_ID,Gender,Age,City,Region) VALUES ('CU010','Female',32,'Chennai','South');
INSERT INTO dim_customers (Customer_ID,Gender,Age,City,Region) VALUES ('CU011','Male',45,'Delhi','North');
INSERT INTO dim_customers (Customer_ID,Gender,Age,City,Region) VALUES ('CU012','Female',27,'Bangalore','South');
INSERT INTO dim_customers (Customer_ID,Gender,Age,City,Region) VALUES ('CU013','Male',36,'Mumbai','West');
INSERT INTO dim_customers (Customer_ID,Gender,Age,City,Region) VALUES ('CU014','Female',30,'Hyderabad','South');
INSERT INTO dim_customers (Customer_ID,Gender,Age,City,Region) VALUES ('CU015','Male',22,'Pune','West');
INSERT INTO dim_customers (Customer_ID,Gender,Age,City,Region) VALUES ('CU016','Female',39,'Kochi','South');
INSERT INTO dim_customers (Customer_ID,Gender,Age,City,Region) VALUES ('CU017','Male',33,'Chennai','South');
INSERT INTO dim_customers (Customer_ID,Gender,Age,City,Region) VALUES ('CU018','Female',25,'Kolkata','East');
INSERT INTO dim_customers (Customer_ID,Gender,Age,City,Region) VALUES ('CU019','Male',48,'Delhi','North');
INSERT INTO dim_customers (Customer_ID,Gender,Age,City,Region) VALUES ('CU020','Female',35,'Mumbai','West');
INSERT INTO dim_customers (Customer_ID,Gender,Age,City,Region) VALUES ('CU021','Male',29,'Coimbatore','South');
INSERT INTO dim_customers (Customer_ID,Gender,Age,City,Region) VALUES ('CU022','Female',42,'Bangalore','South');
INSERT INTO dim_customers (Customer_ID,Gender,Age,City,Region) VALUES ('CU023','Male',27,'Hyderabad','South');
INSERT INTO dim_customers (Customer_ID,Gender,Age,City,Region) VALUES ('CU024','Female',31,'Chennai','South');
INSERT INTO dim_customers (Customer_ID,Gender,Age,City,Region) VALUES ('CU025','Male',38,'Pune','West');

-- DIM_PRODUCTS
INSERT INTO dim_products (Product_ID,Product_Name,Category) VALUES (1,'Wireless Mouse','Electronics');
INSERT INTO dim_products (Product_ID,Product_Name,Category) VALUES (2,'Running Shoes','Fashion');
INSERT INTO dim_products (Product_ID,Product_Name,Category) VALUES (3,'Smart Watch','Electronics');
INSERT INTO dim_products (Product_ID,Product_Name,Category) VALUES (4,'Backpack','Fashion');
INSERT INTO dim_products (Product_ID,Product_Name,Category) VALUES (5,'Office Chair','Furniture');
INSERT INTO dim_products (Product_ID,Product_Name,Category) VALUES (6,'Bluetooth Speaker','Electronics');
INSERT INTO dim_products (Product_ID,Product_Name,Category) VALUES (7,'Jeans','Fashion');
INSERT INTO dim_products (Product_ID,Product_Name,Category) VALUES (8,'Coffee Maker','Home Appliances');
INSERT INTO dim_products (Product_ID,Product_Name,Category) VALUES (9,'Keyboard','Electronics');
INSERT INTO dim_products (Product_ID,Product_Name,Category) VALUES (10,'Handbag','Fashion');
INSERT INTO dim_products (Product_ID,Product_Name,Category) VALUES (11,'Monitor','Electronics');
INSERT INTO dim_products (Product_ID,Product_Name,Category) VALUES (12,'Yoga Mat','Sports');
INSERT INTO dim_products (Product_ID,Product_Name,Category) VALUES (13,'Air Fryer','Home Appliances');
INSERT INTO dim_products (Product_ID,Product_Name,Category) VALUES (14,'Smartphone','Electronics');
INSERT INTO dim_products (Product_ID,Product_Name,Category) VALUES (15,'T-Shirt','Fashion');
INSERT INTO dim_products (Product_ID,Product_Name,Category) VALUES (16,'Table Lamp','Home Appliances');
INSERT INTO dim_products (Product_ID,Product_Name,Category) VALUES (17,'Power Bank','Electronics');
INSERT INTO dim_products (Product_ID,Product_Name,Category) VALUES (18,'Formal Shoes','Fashion');
INSERT INTO dim_products (Product_ID,Product_Name,Category) VALUES (19,'Books','Books');
INSERT INTO dim_products (Product_ID,Product_Name,Category) VALUES (20,'Headphones','Electronics');
INSERT INTO dim_products (Product_ID,Product_Name,Category) VALUES (21,'Electric Kettle','Home Appliances');
INSERT INTO dim_products (Product_ID,Product_Name,Category) VALUES (22,'Dress','Fashion');
INSERT INTO dim_products (Product_ID,Product_Name,Category) VALUES (23,'USB Cable','Electronics');
INSERT INTO dim_products (Product_ID,Product_Name,Category) VALUES (24,'Air Purifier','Home Appliances');
INSERT INTO dim_products (Product_ID,Product_Name,Category) VALUES (25,'Laptop Stand','Electronics');

-- FACT_ORDERS
INSERT INTO fact_orders (Order_ID,Order_Date,Order_Time,Customer_ID,Product_ID,Quantity,Unit_Price,Discount,Cost,Payment_Method,Order_Status,Session_Duration,Pages_Viewed,Order_Completed,Shipping_Days,Return_Status,Customer_Type_At_Order) VALUES ('ORD1001','2026-01-03','10:15','CU001',1,2,799,0.05,1100,'UPI','Delivered',8.5,6,1,3,'No','New');
INSERT INTO fact_orders (Order_ID,Order_Date,Order_Time,Customer_ID,Product_ID,Quantity,Unit_Price,Discount,Cost,Payment_Method,Order_Status,Session_Duration,Pages_Viewed,Order_Completed,Shipping_Days,Return_Status,Customer_Type_At_Order) VALUES ('ORD1002','2026-01-04','14:20','CU002',2,1,2499,0.1,1500,'Card','Delivered',12.2,9,1,4,'No','Returning');
INSERT INTO fact_orders (Order_ID,Order_Date,Order_Time,Customer_ID,Product_ID,Quantity,Unit_Price,Discount,Cost,Payment_Method,Order_Status,Session_Duration,Pages_Viewed,Order_Completed,Shipping_Days,Return_Status,Customer_Type_At_Order) VALUES ('ORD1003','2026-01-05','19:45','CU003',3,1,3999,0.08,2700,'UPI','Delivered',15.4,11,1,3,'No','New');
INSERT INTO fact_orders (Order_ID,Order_Date,Order_Time,Customer_ID,Product_ID,Quantity,Unit_Price,Discount,Cost,Payment_Method,Order_Status,Session_Duration,Pages_Viewed,Order_Completed,Shipping_Days,Return_Status,Customer_Type_At_Order) VALUES ('ORD1004','2026-01-06','21:10','CU004',4,2,1499,0.15,1800,'Card','Delivered',9.8,7,1,5,'Yes','Returning');
INSERT INTO fact_orders (Order_ID,Order_Date,Order_Time,Customer_ID,Product_ID,Quantity,Unit_Price,Discount,Cost,Payment_Method,Order_Status,Session_Duration,Pages_Viewed,Order_Completed,Shipping_Days,Return_Status,Customer_Type_At_Order) VALUES ('ORD1005','2026-01-07','11:30','CU005',5,1,6999,0.05,5200,'Net Banking','Delivered',18.1,13,1,6,'No','Returning');
INSERT INTO fact_orders (Order_ID,Order_Date,Order_Time,Customer_ID,Product_ID,Quantity,Unit_Price,Discount,Cost,Payment_Method,Order_Status,Session_Duration,Pages_Viewed,Order_Completed,Shipping_Days,Return_Status,Customer_Type_At_Order) VALUES ('ORD1006','2026-01-08','16:05','CU006',6,2,1299,0.12,1500,'UPI','Delivered',7.4,5,1,3,'No','New');
INSERT INTO fact_orders (Order_ID,Order_Date,Order_Time,Customer_ID,Product_ID,Quantity,Unit_Price,Discount,Cost,Payment_Method,Order_Status,Session_Duration,Pages_Viewed,Order_Completed,Shipping_Days,Return_Status,Customer_Type_At_Order) VALUES ('ORD1007','2026-01-09','20:35','CU007',7,3,1899,0.1,3600,'Card','Delivered',11.6,8,1,4,'No','Returning');
INSERT INTO fact_orders (Order_ID,Order_Date,Order_Time,Customer_ID,Product_ID,Quantity,Unit_Price,Discount,Cost,Payment_Method,Order_Status,Session_Duration,Pages_Viewed,Order_Completed,Shipping_Days,Return_Status,Customer_Type_At_Order) VALUES ('ORD1008','2026-01-10','09:50','CU008',8,1,3299,0.07,2300,'UPI','Delivered',14.3,10,1,3,'No','New');
INSERT INTO fact_orders (Order_ID,Order_Date,Order_Time,Customer_ID,Product_ID,Quantity,Unit_Price,Discount,Cost,Payment_Method,Order_Status,Session_Duration,Pages_Viewed,Order_Completed,Shipping_Days,Return_Status,Customer_Type_At_Order) VALUES ('ORD1009','2026-01-11','18:25','CU009',9,1,1799,0.05,1200,'Card','Cancelled',6.2,4,0,0,'No','New');
INSERT INTO fact_orders (Order_ID,Order_Date,Order_Time,Customer_ID,Product_ID,Quantity,Unit_Price,Discount,Cost,Payment_Method,Order_Status,Session_Duration,Pages_Viewed,Order_Completed,Shipping_Days,Return_Status,Customer_Type_At_Order) VALUES ('ORD1010','2026-01-12','22:15','CU010',10,1,2799,0.12,1700,'UPI','Delivered',13.7,9,1,4,'No','Returning');
INSERT INTO fact_orders (Order_ID,Order_Date,Order_Time,Customer_ID,Product_ID,Quantity,Unit_Price,Discount,Cost,Payment_Method,Order_Status,Session_Duration,Pages_Viewed,Order_Completed,Shipping_Days,Return_Status,Customer_Type_At_Order) VALUES ('ORD1011','2026-01-13','13:40','CU011',11,1,8999,0.08,6900,'Card','Delivered',21.5,15,1,5,'No','Returning');
INSERT INTO fact_orders (Order_ID,Order_Date,Order_Time,Customer_ID,Product_ID,Quantity,Unit_Price,Discount,Cost,Payment_Method,Order_Status,Session_Duration,Pages_Viewed,Order_Completed,Shipping_Days,Return_Status,Customer_Type_At_Order) VALUES ('ORD1012','2026-01-14','17:55','CU012',12,2,899,0.05,1000,'UPI','Delivered',8.1,6,1,3,'No','New');
INSERT INTO fact_orders (Order_ID,Order_Date,Order_Time,Customer_ID,Product_ID,Quantity,Unit_Price,Discount,Cost,Payment_Method,Order_Status,Session_Duration,Pages_Viewed,Order_Completed,Shipping_Days,Return_Status,Customer_Type_At_Order) VALUES ('ORD1013','2026-01-15','20:20','CU013',13,1,5499,0.1,3900,'Card','Delivered',16.8,12,1,4,'No','Returning');
INSERT INTO fact_orders (Order_ID,Order_Date,Order_Time,Customer_ID,Product_ID,Quantity,Unit_Price,Discount,Cost,Payment_Method,Order_Status,Session_Duration,Pages_Viewed,Order_Completed,Shipping_Days,Return_Status,Customer_Type_At_Order) VALUES ('ORD1014','2026-01-16','12:10','CU014',14,1,18999,0.06,15500,'Net Banking','Delivered',24.3,17,1,5,'No','New');
INSERT INTO fact_orders (Order_ID,Order_Date,Order_Time,Customer_ID,Product_ID,Quantity,Unit_Price,Discount,Cost,Payment_Method,Order_Status,Session_Duration,Pages_Viewed,Order_Completed,Shipping_Days,Return_Status,Customer_Type_At_Order) VALUES ('ORD1015','2026-01-17','19:05','CU015',15,4,799,0.15,1900,'UPI','Delivered',10.2,7,1,3,'Yes','New');
INSERT INTO fact_orders (Order_ID,Order_Date,Order_Time,Customer_ID,Product_ID,Quantity,Unit_Price,Discount,Cost,Payment_Method,Order_Status,Session_Duration,Pages_Viewed,Order_Completed,Shipping_Days,Return_Status,Customer_Type_At_Order) VALUES ('ORD1016','2026-01-18','15:35','CU016',16,2,1199,0.05,1300,'Card','Delivered',7.9,5,1,3,'No','Returning');
INSERT INTO fact_orders (Order_ID,Order_Date,Order_Time,Customer_ID,Product_ID,Quantity,Unit_Price,Discount,Cost,Payment_Method,Order_Status,Session_Duration,Pages_Viewed,Order_Completed,Shipping_Days,Return_Status,Customer_Type_At_Order) VALUES ('ORD1017','2026-01-19','21:45','CU017',17,2,1599,0.1,1900,'UPI','Delivered',12.5,9,1,4,'No','Returning');
INSERT INTO fact_orders (Order_ID,Order_Date,Order_Time,Customer_ID,Product_ID,Quantity,Unit_Price,Discount,Cost,Payment_Method,Order_Status,Session_Duration,Pages_Viewed,Order_Completed,Shipping_Days,Return_Status,Customer_Type_At_Order) VALUES ('ORD1018','2026-01-20','10:55','CU018',18,1,2999,0.08,2100,'Card','Delivered',14.9,10,1,5,'No','New');
INSERT INTO fact_orders (Order_ID,Order_Date,Order_Time,Customer_ID,Product_ID,Quantity,Unit_Price,Discount,Cost,Payment_Method,Order_Status,Session_Duration,Pages_Viewed,Order_Completed,Shipping_Days,Return_Status,Customer_Type_At_Order) VALUES ('ORD1019','2026-01-21','18:40','CU019',19,5,499,0.05,1400,'UPI','Delivered',9.1,7,1,3,'No','Returning');
INSERT INTO fact_orders (Order_ID,Order_Date,Order_Time,Customer_ID,Product_ID,Quantity,Unit_Price,Discount,Cost,Payment_Method,Order_Status,Session_Duration,Pages_Viewed,Order_Completed,Shipping_Days,Return_Status,Customer_Type_At_Order) VALUES ('ORD1020','2026-01-22','20:50','CU020',20,1,2499,0.1,1600,'Card','Delivered',17.2,12,1,4,'No','Returning');
INSERT INTO fact_orders (Order_ID,Order_Date,Order_Time,Customer_ID,Product_ID,Quantity,Unit_Price,Discount,Cost,Payment_Method,Order_Status,Session_Duration,Pages_Viewed,Order_Completed,Shipping_Days,Return_Status,Customer_Type_At_Order) VALUES ('ORD1021','2026-01-23','11:15','CU021',21,1,1799,0.07,1200,'UPI','Delivered',8.8,6,1,3,'No','New');
INSERT INTO fact_orders (Order_ID,Order_Date,Order_Time,Customer_ID,Product_ID,Quantity,Unit_Price,Discount,Cost,Payment_Method,Order_Status,Session_Duration,Pages_Viewed,Order_Completed,Shipping_Days,Return_Status,Customer_Type_At_Order) VALUES ('ORD1022','2026-01-24','16:30','CU022',22,2,2199,0.12,2500,'Card','Delivered',13.1,9,1,5,'No','Returning');
INSERT INTO fact_orders (Order_ID,Order_Date,Order_Time,Customer_ID,Product_ID,Quantity,Unit_Price,Discount,Cost,Payment_Method,Order_Status,Session_Duration,Pages_Viewed,Order_Completed,Shipping_Days,Return_Status,Customer_Type_At_Order) VALUES ('ORD1023','2026-01-25','19:55','CU023',23,3,499,0.05,700,'UPI','Delivered',5.9,4,1,2,'No','New');
INSERT INTO fact_orders (Order_ID,Order_Date,Order_Time,Customer_ID,Product_ID,Quantity,Unit_Price,Discount,Cost,Payment_Method,Order_Status,Session_Duration,Pages_Viewed,Order_Completed,Shipping_Days,Return_Status,Customer_Type_At_Order) VALUES ('ORD1024','2026-01-26','21:25','CU024',24,1,7999,0.1,5900,'Card','Delivered',20.4,14,1,5,'No','Returning');
INSERT INTO fact_orders (Order_ID,Order_Date,Order_Time,Customer_ID,Product_ID,Quantity,Unit_Price,Discount,Cost,Payment_Method,Order_Status,Session_Duration,Pages_Viewed,Order_Completed,Shipping_Days,Return_Status,Customer_Type_At_Order) VALUES ('ORD1025','2026-01-27','14:45','CU025',25,2,1999,0.08,2400,'UPI','Delivered',11.3,8,1,3,'No','New');
