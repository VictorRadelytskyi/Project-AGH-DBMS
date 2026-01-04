-- Production costs for each product by Period View

-- Prints production costs grouped by date (year, month, week) for each product.

CREATE VIEW dbo.vw_ProductionCostsByPeriod AS

-- Assuming UnitPrice contains 50% of markup and includes labour cost
WITH Constants AS (
    SELECT 0.50 AS MarkupRate
)
SELECT
    YEAR(o.FulfillmentFinish) AS ProductionYear,
    MONTH(o.FulfillmentFinish) AS ProductionMonth,
    DATEPART(ISO_WEEK, o.FulfillmentFinish) AS ProductionWeek,
    p.ProductName,
    SUM(od.Quantity * od.UnitPrice / (1 + c.MarkupRate)) AS TotalCost,
    SUM(od.Quantity) AS TotalQuantityProduced,
    SUM(od.Quantity * od.UnitPrice / (1 + c.MarkupRate)) / SUM(od.Quantity) AS AvgUnitCost
FROM Orders o
INNER JOIN OrderDetails od ON od.OrderID = o.ID
INNER JOIN Products p ON p.ID = od.ProductID
CROSS JOIN Constants c
WHERE o.FulfillmentFinish IS NOT NULL
GROUP BY YEAR(o.FulfillmentFinish), MONTH(o.FulfillmentFinish), DATEPART(ISO_WEEK, o.FulfillmentFinish), p.ProductName;
GO