/*
Production costs by Category and Period View

**Description:** Summarizes production costs grouped by year, month, ISO week, and product category.

## Notes

- Assumes `UnitPrice` includes a 50% markup and labor cost; the view removes the markup to approximate production cost.
*/

CREATE VIEW dbo.vw_ProductionCostsByCategoryPeriod AS
WITH Constants AS (
    SELECT 0.50 AS MarkupRate
)
SELECT
    YEAR(o.FulfillmentFinish) AS ProductionYear,
    MONTH(o.FulfillmentFinish) AS ProductionMonth,
    DATEPART(ISO_WEEK, o.FulfillmentFinish) AS ProductionWeek,
    cat.CategoryName,
    SUM(od.Quantity * od.UnitPrice / (1 + c.MarkupRate)) AS TotalCost,
    SUM(od.Quantity) AS TotalQuantityProduced,
    SUM(od.Quantity * od.UnitPrice / (1 + c.MarkupRate)) / SUM(od.Quantity) AS AvgUnitCost
FROM Orders o
INNER JOIN OrderDetails od ON od.OrderID = o.ID
INNER JOIN Products p ON p.ID = od.ProductID
INNER JOIN Categories cat ON cat.ID = p.CategoryID
CROSS JOIN Constants c
WHERE o.FulfillmentFinish IS NOT NULL
GROUP BY YEAR(o.FulfillmentFinish), MONTH(o.FulfillmentFinish), DATEPART(ISO_WEEK, o.FulfillmentFinish), cat.CategoryName;
GO
