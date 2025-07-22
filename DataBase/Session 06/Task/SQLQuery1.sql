use StoreDB


DECLARE @CustomerId INT = 1;
DECLARE @TotalSpent DECIMAL(10, 2)

SELECT @TotalSpent = SUM(oi.quantity * p.list_price)
FROM sales.orders o
JOIN sales.order_items oi ON o.order_id = oi.order_id
JOIN production.products p ON oi.product_id = p.product_id
WHERE o.customer_id = @CustomerId

IF @TotalSpent > 5000
    PRINT 'Customer ' + CAST(@CustomerId AS VARCHAR) + ' is a VIP customer: ' + CAST(@TotalSpent AS VARCHAR)
ELSE
    PRINT 'Customer ' + CAST(@CustomerId AS VARCHAR) + ' is a regular customer: ' + CAST(@TotalSpent AS VARCHAR)


--2
DECLARE @Threshold DECIMAL(10, 2) = 1600
DECLARE @ProductCount INT

SELECT @ProductCount = COUNT(*)
FROM production.products
WHERE list_price > @Threshold

PRINT 'Threshold Price:' + CAST(@Threshold AS VARCHAR)
PRINT 'Number of products  threshold: ' + CAST(@ProductCount AS VARCHAR)

--3
DECLARE @StaffId INT = 2
DECLARE @Year INT = 2019
DECLARE @TotalSales DECIMAL(10, 2)

SELECT @TotalSales = SUM(oi.quantity * p.list_price)
FROM sales.orders o
JOIN sales.order_items oi ON o.order_id = oi.order_id
JOIN production.products p ON oi.product_id = p.product_id
WHERE o.staff_id = @StaffId AND YEAR(o.order_date) = @Year

PRINT 'Staff ID: ' + CAST(@StaffId AS VARCHAR)
PRINT 'Year' + CAST(@Year AS VARCHAR)
PRINT 'Total Sales: ' + CAST(ISNULL(@TotalSales, 0) AS VARCHAR)

--4
SELECT 
    @@SERVERNAME AS Server_Name,
    @@VERSION AS SQL_Server_Version
UPDATE production.products SET list_price = list_price WHERE 1 = 0

SELECT @@ROWCOUNT AS Rows_Affected
SELECT 
    @@SERVERNAME AS Server_Name,
    @@VERSION AS SQL_Server_Version
UPDATE production.products SET list_price = list_price WHERE 1 = 0
SELECT @@ROWCOUNT AS Rows_Affected

--5
DECLARE @ProductId INT = 1
DECLARE @StoreId INT = 1
DECLARE @Quantity INT

SELECT @Quantity = quantity
FROM production.stocks
WHERE product_id = @ProductId AND store_id = @StoreId

IF @Quantity > 20
    PRINT 'Well stocked'
ELSE IF @Quantity BETWEEN 10 AND 20
    PRINT 'Moderate stock';
ELSE IF @Quantity < 10
    PRINT 'reorder needed'
ELSE
    PRINT 'Product not found in inventory'


--6
DECLARE @BatchSize INT = 3
DECLARE @UpdatedCount INT = 0

WHILE EXISTS (
    SELECT 1 FROM production.stocks WHERE quantity < 5
)
BEGIN
    UPDATE TOP (@BatchSize) production.stocks
    SET quantity = quantity + 10
    WHERE quantity < 5
    SET @UpdatedCount += @@ROWCOUNT
    PRINT 'Batch updated. Total updated so far: ' + CAST(@UpdatedCount AS VARCHAR);
END


--7
SELECT 
    product_id,
    product_name,
    list_price,
    CASE 
        WHEN list_price < 300 THEN 'Budget'
        WHEN list_price BETWEEN 300 AND 800 THEN 'Mid-Range'
        WHEN list_price BETWEEN 801 AND 2000 THEN 'Premium'
        WHEN list_price > 2000 THEN 'Luxury'
        ELSE 'Unknown'
    END AS Price_Category
FROM production.products

--8
Go
DECLARE @CustomerId INT = 5
DECLARE @OrderCount INT

IF EXISTS (SELECT 1 FROM sales.customers WHERE customer_id = @CustomerId)
BEGIN
    SELECT @OrderCount = COUNT(*) 
    FROM sales.orders 
    WHERE customer_id = @CustomerId

    PRINT 'Customer exists. Order count: ' + CAST(@OrderCount AS VARCHAR)
END
ELSE
BEGIN
    PRINT 'Customer with ID ' + CAST(@CustomerId AS VARCHAR) + ' does not exist.'
END


Go
--9
CREATE FUNCTION CalculateShipping (@Total DECIMAL(10,2))
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @ShippingCost DECIMAL(10,2)
    IF @Total > 100
        SET @ShippingCost = 0
    ELSE IF @Total BETWEEN 50 AND 99.99
        SET @ShippingCost = 5.99
    ELSE
        SET @ShippingCost = 12.99

    RETURN @ShippingCost
END
Go

select dbo.CalculateShipping(10.5)

Go

--10
CREATE FUNCTION dbo.GetProductsByPriceRange
(
    @MinPrice DECIMAL(10,2),
    @MaxPrice DECIMAL(10,2)
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        p.product_id,
        p.product_name,
        p.list_price,
        b.brand_name,
        c.category_name
    FROM production.products p
    JOIN production.brands b ON p.brand_id = b.brand_id
    JOIN production.categories c ON p.category_id = c.category_id
    WHERE p.list_price BETWEEN @MinPrice AND @MaxPrice
)

Go
SELECT * 
FROM dbo.GetProductsByPriceRange(300, 800)
Go

--11
CREATE FUNCTION dbo.GetCustomerYearlySummary (
    @CustomerID INT
)
RETURNS @Summary TABLE (
    OrderYear INT,
    TotalOrders INT,
    TotalSpent DECIMAL(10,2),
    AverageOrderValue DECIMAL(10,2)
)
AS
BEGIN
    INSERT INTO @Summary
    SELECT 
        YEAR(o.order_date) AS OrderYear,
        COUNT(DISTINCT o.order_id) AS TotalOrders,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS TotalSpent,
        AVG(oi.quantity * oi.list_price * (1 - oi.discount)) AS AverageOrderValue
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    WHERE o.customer_id = @CustomerID
    GROUP BY YEAR(o.order_date)

    RETURN
END
GO
SELECT * FROM dbo.GetCustomerYearlySummary(1)
Go
-- 12
CREATE FUNCTION dbo.CalculateBulkDiscount (@Quantity INT)
RETURNS DECIMAL(5,2)
AS
BEGIN
    RETURN
        CASE
            WHEN @Quantity BETWEEN 1 AND 2 THEN 0.00
            WHEN @Quantity BETWEEN 3 AND 5 THEN 0.05
            WHEN @Quantity BETWEEN 6 AND 9 THEN 0.10
            ELSE 0.15
        END
END
Go
-- 13
CREATE PROCEDURE dbo.sp_GetCustomerOrderHistory
    @CustomerID INT,
    @StartDate DATE = NULL,
    @EndDate DATE = NULL
AS
BEGIN
    SELECT o.order_id, o.order_date, SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS OrderTotal
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    WHERE o.customer_id = @CustomerID
        AND (@StartDate IS NULL OR o.order_date >= @StartDate)
        AND (@EndDate IS NULL OR o.order_date <= @EndDate)
    GROUP BY o.order_id, o.order_date
END
Go

-- 14
CREATE PROCEDURE dbo.sp_RestockProduct
    @StoreID INT,
    @ProductID INT,
    @RestockQty INT,
    @OldQty INT OUTPUT,
    @NewQty INT OUTPUT,
    @Success BIT OUTPUT
AS
BEGIN
    BEGIN TRY
        SELECT @OldQty = quantity FROM production.stocks WHERE store_id = @StoreID AND product_id = @ProductID
        UPDATE production.stocks
        SET quantity = quantity + @RestockQty
        WHERE store_id = @StoreID AND product_id = @ProductID;
        SELECT @NewQty = quantity FROM production.stocks WHERE store_id = @StoreID AND product_id = @ProductID
        SET @Success = 1
    END TRY
    BEGIN CATCH
        SET @Success = 0
    END CATCH
END
Go