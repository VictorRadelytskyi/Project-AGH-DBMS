/*
To have better performance in:

Get Total Component Stock Function
Calculate Component Avg Cost Function
*/

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_ComponentsInventory_ComponentID_InventoryDate_Include')
CREATE NONCLUSTERED INDEX IX_ComponentsInventory_ComponentID_InventoryDate_Include
ON dbo.ComponentsInventory (ComponentID, InventoryDate)
INCLUDE (UnitsInStock, UnitPrice);
GO
