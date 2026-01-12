-- List of components that need restocking

-- Prints a list of components that have critically low stock in ComponentsInventory

CREATE VIEW dbo.vw_ComponentsToOrder AS

WITH Constants AS (
    SELECT 500 AS CriticalStockQuantity
),
StockData AS (
    SELECT
        c.ID,
        c.ComponentName,
        c.ComponentType,
        dbo.fn_GetTotalComponentsInStock(c.ID) AS TotalUnitsInStock,
        dbo.fn_GetSupplierContactInfoByComponent(c.ID) AS SupplierContact,
        cnt.CriticalStockQuantity
    FROM Components c
    CROSS JOIN Constants cnt
)
SELECT
    ID AS ComponentID,
    ComponentName,
    ComponentType,
    TotalUnitsInStock,
    SupplierContact
FROM StockData
WHERE TotalUnitsInStock < CriticalStockQuantity;
GO
