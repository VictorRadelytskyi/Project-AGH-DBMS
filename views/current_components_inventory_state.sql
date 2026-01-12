-- Components inventory count by component

-- Prints total units in stock, oldest batch age in days and current average cost for each component

CREATE VIEW dbo.vw_CurrentComponentsInventoryState AS
SELECT
    c.ID AS ComponentID,
    c.ComponentName,
    c.ComponentType,
    s.CompanyName AS Supplier,
    dbo.fn_GetTotalComponentsInStock(c.ID) AS TotalUnitsInStock,
    dbo.fn_GetComponentInventoryAgeDays(c.ID) AS OldestBatchAgeDays,
    dbo.fn_CalculateComponentWeightedAvgCost(c.ID) AS CurrentAvgUnitCost
FROM Components c
INNER JOIN Suppliers s ON s.ID = c.SupplierID;
GO
