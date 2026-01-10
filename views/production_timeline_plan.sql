/*
VIEW: vw_ProductionTimelinePlan

PURPOSE: 
Acts as a Master Production Schedule (MPS) for the manufacturing department. 
It aggregates all unfulfilled order quantities into weekly time-buckets to 
allow for workload forecasting and resource planning.

LOGIC:
1. Filtering: Only considers order lines where Quantity > QuantityFulfilled.
2. Temporal Grouping: Buckets demand by Year and ISO Week based on OrderDate.
3. Capacity Calculation: Joins with ProductRecipes to calculate the total 
   LabourHours required to clear the specific week's backlog.

COLUMNS:
- ProductName: Name of the furniture/product to be manufactured.
- OrderYear/OrderWeek: The time period when the demand was generated.
- UnitsToManufacture: Total quantity still required for fulfillment.
- EstimatedLabourHoursNeeded: (UnitsToManufacture * Recipe.LabourHours).

USAGE:
SELECT * FROM dbo.vw_ProductionTimelinePlan 
ORDER BY OrderYear, OrderWeek, ProductName;
*/

CREATE VIEW vw_ProductionTimelinePlan
AS
SELECT 
    p.ProductName,
    DATEPART(year, o.OrderDate) AS OrderYear,
    DATEPART(week, o.OrderDate) AS OrderWeek,
    SUM(od.Quantity - od.QuantityFulfilled) AS UnitsToManufacture,
    SUM((od.Quantity - od.QuantityFulfilled) * pr.LabourHours) AS EstimatedLabourHoursNeeded
FROM Orders o
JOIN OrderDetails od ON o.ID = od.OrderID
JOIN Products p ON od.ProductID = p.ID
JOIN ProductRecipes pr ON p.ProductRecipesID = pr.ID
-- only what is not ready yet
WHERE od.Quantity > od.QuantityFulfilled 
GROUP BY 
    p.ProductName, 
    DATEPART(year, o.OrderDate), 
    DATEPART(week, o.OrderDate);
GO