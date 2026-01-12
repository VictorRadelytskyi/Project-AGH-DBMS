/*
Logistics agents
*/

-- Role for employees responsible for logistics
CREATE ROLE Role_LogisticsAgent;
GO

-- grant read access to tables that store location information
GRANT SELECT ON dbo.Warehouse TO Role_LogisticsAgent;
GRANT SELECT ON dbo.Suppliers TO Role_LogisticsAgent;
GRANT SELECT ON dbo.Components TO Role_LogisticsAgent;
GRANT SELECT ON dbo.ComponentsInventory TO Role_LogisticsAgent;

-- allow warehouse, component and supplier management
GRANT EXECUTE ON dbo.AddComponent TO Role_LogisticsAgent;
GRANT EXECUTE ON dbo.UpdateComponent TO Role_LogisticsAgent;
GRANT EXECUTE ON dbo.AddComponentInventory TO Role_LogisticsAgent;
GRANT EXECUTE ON dbo.AddProductToWarehouse TO Role_LogisticsAgent;
GRANT EXECUTE ON dbo.AddSupplier TO Role_LogisticsAgent;
GRANT EXECUTE ON dbo.UpdateSupplier TO Role_LogisticsAgent;
GRANT EXECUTE ON dbo.RemoveComponent TO Role_LogisticsAgent;

-- allow warehouse monitoring
GRANT SELECT ON dbo.vw_CategoryStockValuation TO Role_LogisticsAgent;
GRANT SELECT ON dbo.vw_InventoryShortageList TO Role_LogisticsAgent;
GRANT SELECT ON dbo.vw_ProductsInLocation TO Role_LogisticsAgent;
GO
