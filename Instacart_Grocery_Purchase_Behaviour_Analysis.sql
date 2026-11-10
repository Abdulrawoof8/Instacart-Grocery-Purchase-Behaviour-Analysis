CREATE DATABASE Instacart_Grocery_Analysis;

USE Instacart_Grocery_Analysis;


SELECT
    COUNT(*) AS Total_Products,
    COUNT(DISTINCT product_id) AS Unique_Product_IDs,
    MIN(product_id) AS First_Product_ID,
    MAX(product_id) AS Last_Product_ID
FROM products;

select top 5 * from [dbo].[orders]


SELECT COUNT(*) AS Total_Rows
FROM [dbo].[aisles]

SELECT COUNT(*) AS Total_Rows
FROM [dbo].[departments]

SELECT COUNT(*) AS Total_Rows
FROM products;

SELECT COUNT(*) AS Total_Rows
FROM orders;

SELECT COUNT(*) AS Total_Rows
FROM order_products_prior;

SELECT COUNT(*) AS Total_Rows
FROM[dbo].[order_products__train] 


SELECT
    aisle_id,
    COUNT(*) AS ID_Count
FROM aisles
GROUP BY aisle_id
HAVING COUNT(*) > 1;


SELECT
    product_id,
    COUNT(*) AS ID_Count
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;


SELECT
    order_id,
    COUNT(*) AS ID_Count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT
    order_id,
    product_id,
    COUNT(*) AS Duplicate_Count
FROM order_products_prior
GROUP BY
    order_id,
    product_id
HAVING COUNT(*) > 1;


SELECT
    order_id,
    product_id,
    COUNT(*) AS Duplicate_Count
FROM [dbo].[order_products__train]
GROUP BY
    order_id,
    product_id
HAVING COUNT(*) > 1;

SELECT
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS Null_Order_ID,
    SUM(CASE WHEN user_id IS NULL THEN 1 ELSE 0 END) AS Null_User_ID,
    SUM(CASE WHEN eval_set IS NULL THEN 1 ELSE 0 END) AS Null_Eval_Set,
    SUM(CASE WHEN order_number IS NULL THEN 1 ELSE 0 END) AS Null_Order_Number,
    SUM(CASE WHEN order_dow IS NULL THEN 1 ELSE 0 END) AS Null_Order_DOW,
    SUM(CASE WHEN order_hour_of_day IS NULL THEN 1 ELSE 0 END) AS Null_Order_Hour,
    SUM(CASE WHEN days_since_prior_order IS NULL THEN 1 ELSE 0 END) AS Null_Days
FROM orders;


SELECT
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS Null_Product_ID,
    SUM(CASE WHEN product_name IS NULL THEN 1 ELSE 0 END) AS Null_Product_Name,
    SUM(CASE WHEN aisle_id IS NULL THEN 1 ELSE 0 END) AS Null_Aisle_ID,
    SUM(CASE WHEN department_id IS NULL THEN 1 ELSE 0 END) AS Null_Department_ID
FROM products;


SELECT
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS Null_Order_ID,
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS Null_Product_ID,
    SUM(CASE WHEN add_to_cart_order IS NULL THEN 1 ELSE 0 END) AS Null_Add_To_Cart,
    SUM(CASE WHEN reordered IS NULL THEN 1 ELSE 0 END) AS Null_Reordered
FROM order_products_prior;


SELECT
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS Null_Order_ID,
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS Null_Product_ID,
    SUM(CASE WHEN add_to_cart_order IS NULL THEN 1 ELSE 0 END) AS Null_Add_To_Cart,
    SUM(CASE WHEN reordered IS NULL THEN 1 ELSE 0 END) AS Null_Reordered
FROM [dbo].[order_products__train];


SELECT
    SUM(CASE WHEN aisle_id IS NULL THEN 1 ELSE 0 END) AS Null_Aisle_ID,
    SUM(CASE WHEN aisle IS NULL THEN 1 ELSE 0 END) AS Null_Aisle_Name
FROM aisles;


SELECT
    SUM(CASE WHEN department_id IS NULL THEN 1 ELSE 0 END) AS Null_Department_ID,
    SUM(CASE WHEN department IS NULL THEN 1 ELSE 0 END) AS Null_Department_Name
FROM departments;


SELECT
    p.product_id,
    p.aisle_id
FROM products AS p
LEFT JOIN aisles AS a
    ON p.aisle_id = a.aisle_id
WHERE a.aisle_id IS NULL;


SELECT
    p.product_id,
    p.department_id
FROM products AS p
LEFT JOIN departments AS d
    ON p.department_id = d.department_id
WHERE d.department_id IS NULL;


SELECT
    COUNT(*) AS Missing_Order_References
FROM order_products_prior AS op
LEFT JOIN orders AS o
    ON op.order_id = o.order_id
WHERE o.order_id IS NULL;



SELECT
    COUNT(*) AS Missing_Order_References
FROM [dbo].[order_products__train] AS op
LEFT JOIN orders AS o
    ON op.order_id = o.order_id
WHERE o.order_id IS NULL;



SELECT
    COUNT(*) AS Missing_Product_References
FROM order_products_prior AS op
LEFT JOIN products AS p
    ON op.product_id = p.product_id
WHERE p.product_id IS NULL;



SELECT
    name AS Table_Name,
    index_id,
    is_primary_key
FROM sys.indexes
WHERE object_id IN (
    OBJECT_ID('aisles'),
    OBJECT_ID('departments'),
    OBJECT_ID('orders'),
    OBJECT_ID('products'),
    OBJECT_ID('order_products_prior'),
    OBJECT_ID('order_products__train')
)
AND is_primary_key = 1;


ALTER TABLE order_products_prior
ADD CONSTRAINT FK_order_products_prior_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);


ALTER TABLE order_products_prior
ADD CONSTRAINT FK_order_products_prior_products
FOREIGN KEY (product_id)
REFERENCES products(product_id);


ALTER TABLE order_products__train
ADD CONSTRAINT FK_order_products_train_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);


ALTER TABLE order_products__train
ADD CONSTRAINT FK_order_products_train_products
FOREIGN KEY (product_id)
REFERENCES products(product_id);


ALTER TABLE products
ADD CONSTRAINT FK_products_aisles
FOREIGN KEY (aisle_id)
REFERENCES aisles(aisle_id);


ALTER TABLE products
ADD CONSTRAINT FK_products_departments
FOREIGN KEY (department_id)
REFERENCES departments(department_id);


SELECT
    name AS Foreign_Key_Name,
    OBJECT_NAME(parent_object_id) AS Child_Table,
    OBJECT_NAME(referenced_object_id) AS Parent_Table
FROM sys.foreign_keys;



-- Which 10 products are purchased most frequently?
WITH AllPurchases AS
(
    SELECT product_id
    FROM order_products_prior

    UNION ALL

    SELECT product_id
    FROM dbo.order_products__train
)
SELECT TOP 10
    p.product_id,
    p.product_name,
    COUNT(*) AS Total_Purchases
FROM AllPurchases AS ap
INNER JOIN products AS p
    ON ap.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY
    Total_Purchases DESC;

--Department-Wise Purchase Analysis
	WITH AllPurchases AS
(
    SELECT product_id
    FROM order_products_prior

    UNION ALL

    SELECT product_id
    FROM dbo.order_products__train
)
SELECT
    d.department_id,
    d.department,
    COUNT(*) AS Total_Purchases
FROM AllPurchases AS ap
INNER JOIN products AS p
    ON ap.product_id = p.product_id
INNER JOIN departments AS d
    ON p.department_id = d.department_id
GROUP BY
    d.department_id,
    d.department
ORDER BY
    Total_Purchases DESC;


--Customer Ordering Pattern Analysis – Orders by Day of the Week
SELECT
    order_dow,
    COUNT(*) AS Total_Orders
FROM orders
GROUP BY order_dow
ORDER BY Total_Orders DESC;

--Orders by Hour of the Day.
SELECT
    order_hour_of_day,
    COUNT(*) AS Total_Orders
FROM orders
GROUP BY order_hour_of_day
ORDER BY Total_Orders DESC;

-- Orders by Customer Order Sequence
SELECT
    order_number,
    COUNT(*) AS Total_Orders
FROM orders
GROUP BY order_number
ORDER BY order_number;

--Customer Retention Analysis by Order Sequence
WITH CustomerOrders AS
(
    SELECT
        order_number,
        COUNT(DISTINCT user_id) AS Total_Customers
    FROM orders
    GROUP BY order_number
)
SELECT
    order_number,
    Total_Customers,
    CAST(
        100.0 * Total_Customers /
        MAX(CASE WHEN order_number = 1
            THEN Total_Customers END) OVER ()
        AS DECIMAL(5,2)
    ) AS Retention_Percentage
FROM CustomerOrders
ORDER BY order_number;


--: Department-Wise Reorder Rate Analysis
WITH AllPurchases AS
(
    SELECT product_id, reordered
    FROM order_products_prior

    UNION ALL

    SELECT product_id, reordered
    FROM dbo.order_products__train
)
SELECT
    d.department,
    COUNT(*) AS Total_Purchases,
    SUM(CAST(ap.reordered AS INT)) AS Repeated_Purchases,
    CAST(
        100.0 * SUM(CAST(ap.reordered AS INT)) / COUNT(*)
        AS DECIMAL(5,2)
    ) AS Reorder_Rate
FROM AllPurchases AS ap
INNER JOIN products AS p
    ON ap.product_id = p.product_id
INNER JOIN departments AS d
    ON p.department_id = d.department_id
GROUP BY
    d.department,
    d.department_id
ORDER BY
    Reorder_Rate DESC;




--Additional Analysis: Average Days Between Orders by Customer Order Sequence
SELECT
    order_number,
    COUNT(*) AS Total_Orders,
    CAST(
        AVG(days_since_prior_order * 1.0)
        AS DECIMAL(5,2)
    ) AS Average_Days_Between_Orders
FROM orders
WHERE days_since_prior_order IS NOT NULL
GROUP BY order_number
ORDER BY order_number;


--Average Basket Size Analysis
WITH AllOrderProducts AS
(
    SELECT order_id
    FROM order_products_prior

    UNION ALL

    SELECT order_id
    FROM dbo.order_products__train
),
OrderBasket AS
(
    SELECT
        order_id,
        COUNT(*) AS Products_Per_Order
    FROM AllOrderProducts
    GROUP BY order_id
)
SELECT
    COUNT(*) AS Total_Orders,
    CAST(AVG(Products_Per_Order * 1.0) AS DECIMAL(10,2))
        AS Average_Products_Per_Order,
    MIN(Products_Per_Order) AS Minimum_Products,
    MAX(Products_Per_Order) AS Maximum_Products
FROM OrderBasket;


--Additional Analysis: Top 10 Most Frequent Customers
SELECT TOP 10
    user_id,
    COUNT(*) AS Total_Orders
FROM orders
GROUP BY user_id
ORDER BY Total_Orders DESC;