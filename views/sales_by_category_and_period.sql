CREATE VIEW dbo.vw_SalesByCategoryAndPeriod
AS
SELECT
    DATEPART(YEAR,  o.OrderDate) AS OrderYear,
    DATEPART(MONTH, o.OrderDate) AS OrderMonth,
    DATEPART(WEEK,  o.OrderDate) AS OrderWeek,
--    cat.ID                       AS CategoryID,
    cat.CategoryName,
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS NetSalesValue,
    SUM(od.Quantity)             AS UnitsSold,
    COUNT(DISTINCT o.ID)         AS OrdersCount
FROM dbo.OrderDetails AS od
JOIN dbo.Orders     AS o   ON od.OrderID   = o.ID
JOIN dbo.Products   AS p   ON od.ProductID = p.ID
LEFT JOIN dbo.Categories AS cat
    ON p.CategoryID = cat.ID
GROUP BY
    DATEPART(YEAR,  o.OrderDate),
    DATEPART(MONTH, o.OrderDate),
    DATEPART(WEEK,  o.OrderDate),
    cat.ID,
    cat.CategoryName;
GO
