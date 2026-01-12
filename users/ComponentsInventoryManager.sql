/*
Components Inventory Manager

**Description:** Components inventory warehouse floor staff that manages and monitors components stock, orders missing or low stock components.
*/

CREATE ROLE Role_ComponentsInventoryManager;
GO

GRANT SELECT ON dbo.Components TO Role_ComponentsInventoryManager;
GRANT SELECT ON dbo.ComponentsInventory TO Role_ComponentsInventoryManager;
GRANT SELECT ON dbo.Suppliers TO Role_ComponentsInventoryManager;
GRANT SELECT ON dbo.vw_CurrentComponentsInventoryState TO Role_ComponentsInventoryManager;
GRANT SELECT ON dbo.vw_ComponentsToOrder TO Role_ComponentsInventoryManager;

GRANT EXECUTE ON dbo.AddComponentInventory TO Role_ComponentsInventoryManager;
GRANT EXECUTE ON dbo.ConsumeComponentInventory TO Role_ComponentsInventoryManager;
GRANT EXECUTE ON dbo.ConsumeComponentStockFromInventory TO Role_ComponentsInventoryManager;
GRANT EXECUTE ON dbo.fn_GetTotalComponentsInStock TO Role_ComponentsInventoryManager;
GRANT EXECUTE ON dbo.fn_GetComponentInventoryAgeDays TO Role_ComponentsInventoryManager;
GRANT EXECUTE ON dbo.fn_GetSupplierContactInfoByComponent TO Role_ComponentsInventoryManager;
GO

