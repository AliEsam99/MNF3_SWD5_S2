--1
SELECT 
    product_id,
    product_name,
    list_price,
    CASE 
        WHEN list_price < 300 THEN 'Economy'
        WHEN list_price BETWEEN 300 AND 999 THEN 'Standard'
        WHEN list_price BETWEEN 1000 AND 2499 THEN 'Premium'
        ELSE 'Luxury'
    END AS price_category
FROM production.products



--2
SELECT 
    order_id,
    customer_id,
    order_date,
   order_status,
    CASE order_status
        WHEN 1 THEN 'Order Received'
        WHEN 2 THEN 'In Preparation'
        WHEN 3 THEN 'Order Cancelled'
        WHEN 4 THEN 'Order Delivered'
    END AS status_description,
    CASE 
        WHEN order_status = 1 AND DATEDIFF(DAY, order_date, GETDATE()) > 5 THEN 'URGENT'
        WHEN order_status = 2 AND DATEDIFF(DAY, order_date, GETDATE()) > 3 THEN 'HIGH'
        ELSE 'NORMAL'
    END AS priority_level
FROM sales.orders



--3
SELECT 
    s.staff_id,
    s.first_name,
    s.last_name,
    COUNT(o.order_id) AS orders_handled,
    CASE 
        WHEN COUNT(o.order_id) = 0 THEN 'New Staff'
        WHEN COUNT(o.order_id) BETWEEN 1 AND 10 THEN 'Junior Staff'
        WHEN COUNT(o.order_id) BETWEEN 11 AND 25 THEN 'Senior Staff'
        ELSE 'Expert Staff'
    END AS staff_level
FROM sales.staffs s
LEFT JOIN sales.orders o ON s.staff_id = o.staff_id
GROUP BY s.staff_id, s.first_name, s.last_name


--4
SELECT 
    customer_id,
    first_name,
    last_name,
    ISNULL(phone, 'Phone Not Available') AS phone,
    COALESCE(phone, email, 'No Contact Method') AS preferred_contact,
    street, city, state, zip_code
FROM sales.customers

--5
SELECT 
    p.product_id,
    p.product_name,
    s.store_id,
    s.quantity,
    ISNULL(s.quantity, 0) AS available_quantity,
    CASE 
        WHEN s.quantity IS NULL OR s.quantity = 0 THEN 'Out of Stock'
        ELSE 'In Stock'
    END AS stock_status,
    ISNULL(p.list_price / NULLIF(s.quantity, 0), 0) AS price_per_unit
FROM production.products p
JOIN production.stocks s ON p.product_id = s.product_id
WHERE s.store_id = 1


--6
SELECT 
    customer_id,
    first_name,
    last_name,
    COALESCE(street, '') + ', ' +
    COALESCE(city, '') + ', ' +
    COALESCE(state, '') + ' ' +
    COALESCE(zip_code, 'No ZIP') AS formatted_address
FROM sales.customers;


--7
WITH CustomerSpending AS (
    SELECT 
        o.customer_id,
        SUM(oi.list_price * oi.quantity - oi.discount) AS total_spent
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    GROUP BY o.customer_id
)
SELECT c.customer_id, c.first_name, c.last_name, cs.total_spent
FROM CustomerSpending cs
JOIN sales.customers c ON cs.customer_id = c.customer_id
WHERE cs.total_spent > 1500
ORDER BY cs.total_spent DESC


--8
WITH RevenuePerCategory AS (
    SELECT 
        p.category_id,
        SUM(oi.list_price * oi.quantity - oi.discount) AS total_revenue
    FROM production.products p
    JOIN sales.order_items oi ON p.product_id = oi.product_id
    GROUP BY p.category_id
),
AverageOrderValuePerCategory AS (
    SELECT 
        p.category_id,
        AVG(oi.list_price * oi.quantity - oi.discount) AS avg_order_value
    FROM production.products p
    JOIN sales.order_items oi ON p.product_id = oi.product_id
    GROUP BY p.category_id
)
SELECT 
    c.category_name,
    r.total_revenue,
    a.avg_order_value,
    CASE 
        WHEN r.total_revenue > 50000 THEN 'Excellent'
        WHEN r.total_revenue > 20000 THEN 'Good'
        ELSE 'Needs Improvement'
    END AS performance
FROM RevenuePerCategory r
JOIN AverageOrderValuePerCategory a ON r.category_id = a.category_id
JOIN production.categories c ON r.category_id = c.category_id


--9
WITH MonthlySales AS (
    SELECT 
        YEAR(order_date) AS sales_year,
        MONTH(order_date) AS sales_month,
        SUM(oi.list_price * oi.quantity - oi.discount) AS total_revenue
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    GROUP BY YEAR(order_date), MONTH(order_date)
),
MonthlyComparison AS (
    SELECT 
        sales_year,
        sales_month,
        total_revenue,
        LAG(total_revenue) OVER (ORDER BY sales_year, sales_month) AS previous_month_revenue
    FROM MonthlySales
)
SELECT 
    sales_year,
    sales_month,
    total_revenue,
    previous_month_revenue,
    CASE 
        WHEN previous_month_revenue IS NULL THEN NULL
        ELSE ROUND((total_revenue - previous_month_revenue) * 100.0 / previous_month_revenue, 2)
    END AS growth_percentage
FROM MonthlyComparison


--10
SELECT *
FROM (
    SELECT 
        p.category_id,
        p.product_name,
        p.list_price,
        ROW_NUMBER() OVER (PARTITION BY p.category_id ORDER BY p.list_price DESC) AS row_num,
        RANK() OVER (PARTITION BY p.category_id ORDER BY p.list_price DESC) AS rank_num,
        DENSE_RANK() OVER (PARTITION BY p.category_id ORDER BY p.list_price DESC) AS dense_rank_num
    FROM production.products p
) ranked_products
WHERE row_num <= 3


--11
WITH CustomerSpending AS (
    SELECT 
        o.customer_id,
        SUM(oi.list_price * oi.quantity - oi.discount) AS total_spent
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    GROUP BY o.customer_id
)
SELECT 
    cs.customer_id,
    c.first_name,
    c.last_name,
    cs.total_spent,
    RANK() OVER (ORDER BY cs.total_spent DESC) AS spending_rank,
    NTILE(5) OVER (ORDER BY cs.total_spent DESC) AS spending_group,
    CASE 
        WHEN NTILE(5) OVER (ORDER BY cs.total_spent DESC) = 1 THEN 'VIP'
        WHEN NTILE(5) OVER (ORDER BY cs.total_spent DESC) = 2 THEN 'Gold'
        WHEN NTILE(5) OVER (ORDER BY cs.total_spent DESC) = 3 THEN 'Silver'
        WHEN NTILE(5) OVER (ORDER BY cs.total_spent DESC) = 4 THEN 'Bronze'
        ELSE 'Standard'
    END AS spending_tier
FROM CustomerSpending cs
JOIN sales.customers c ON cs.customer_id = c.customer_id


--12
WITH StoreRevenue AS (
    SELECT 
        s.store_id,
        SUM(oi.list_price * oi.quantity - oi.discount) AS total_revenue,
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    JOIN sales.stores s ON o.store_id = s.store_id
    GROUP BY s.store_id
)
SELECT 
    sr.store_id,
    sr.total_revenue,
    sr.total_orders,
    RANK() OVER (ORDER BY sr.total_revenue DESC) AS revenue_rank,
    RANK() OVER (ORDER BY sr.total_orders DESC) AS order_count_rank,
    PERCENT_RANK() OVER (ORDER BY sr.total_revenue DESC) AS revenue_percentile
FROM StoreRevenue sr

--13
SELECT category_name, [Electra], [Haro], [Trek], [Surly]
FROM (
    SELECT 
        c.category_name,
        b.brand_name,
        p.product_id
    FROM production.products p
    JOIN production.categories c ON p.category_id = c.category_id
    JOIN production.brands b ON p.brand_id = b.brand_id
    WHERE b.brand_name IN ('Electra', 'Haro', 'Trek', 'Surly')
) AS SourceTable
PIVOT (
    COUNT(product_id) FOR brand_name IN ([Electra], [Haro], [Trek], [Surly])
) AS PivotTable


--15
SELECT * 
FROM (
    SELECT 
        s.store_name,
        CASE o.order_status
            WHEN 1 THEN 'Pending'
            WHEN 2 THEN 'Processing'
            WHEN 3 THEN 'Completed'
            WHEN 4 THEN 'Rejected'
        END AS status_text
    FROM sales.orders o
    JOIN sales.stores s ON o.store_id = s.store_id
) AS SourceTable
PIVOT (
    COUNT(status_text) FOR status_text IN ([Pending], [Processing], [Completed], [Rejected])
) AS PivotTable

--16
WITH BrandYearRevenue AS (
    SELECT 
        b.brand_name,
        YEAR(o.order_date) AS sales_year,
        SUM(oi.list_price * oi.quantity - oi.discount) AS total_revenue
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    JOIN production.products p ON oi.product_id = p.product_id
    JOIN production.brands b ON p.brand_id = b.brand_id
    WHERE YEAR(o.order_date) IN (2016, 2017, 2018)
    GROUP BY b.brand_name, YEAR(o.order_date)
)
SELECT * 
FROM BrandYearRevenue
PIVOT (
    SUM(total_revenue) FOR sales_year IN ([2016], [2017], [2018])
) AS PivotTable

--17
-- In-stock products
SELECT product_id, 'In Stock' AS availability_status
FROM production.stocks
WHERE quantity > 0
UNION
-- Out-of-stock products
SELECT product_id, 'Out of Stock'
FROM production.stocks
WHERE quantity = 0 OR quantity IS NULL
UNION
-- Discontinued products
SELECT p.product_id, 'Discontinued'
FROM production.products p
WHERE NOT EXISTS (
    SELECT 1 FROM production.stocks s WHERE p.product_id = s.product_id
)

--18
SELECT customer_id
FROM sales.orders
WHERE YEAR(order_date) = 2017
INTERSECT
SELECT customer_id
FROM sales.orders
WHERE YEAR(order_date) = 2018

-- Products in all 3 stores
SELECT product_id
FROM production.stocks
WHERE store_id = 1
INTERSECT
SELECT product_id
FROM production.stocks
WHERE store_id = 2
INTERSECT
SELECT product_id
FROM production.stocks
WHERE store_id = 3

UNION

SELECT product_id
FROM production.stocks
WHERE store_id = 1
EXCEPT
SELECT product_id
FROM production.stocks
WHERE store_id = 2

--20

SELECT customer_id, 'Lost Customer' AS retention_status
FROM sales.orders
WHERE YEAR(order_date) = 2016
EXCEPT
SELECT customer_id, 'Lost Customer'
FROM sales.orders
WHERE YEAR(order_date) = 2017

UNION ALL

SELECT customer_id, 'New Customer'
FROM sales.orders
WHERE YEAR(order_date) = 2017
EXCEPT
SELECT customer_id, 'New Customer'
FROM sales.orders
WHERE YEAR(order_date) = 2016

UNION ALL

SELECT customer_id, 'Retained Customer'
FROM sales.orders
WHERE YEAR(order_date) = 2016
INTERSECT
SELECT customer_id, 'Retained Customer'
FROM sales.orders
WHERE YEAR(order_date) = 2017







