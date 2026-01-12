/*
Components inventory count by component

**Description:** Shows current component inventory levels with supplier info, oldest batch age, and weighted average unit cost.
*/

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
