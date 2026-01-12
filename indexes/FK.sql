/*
Foreign Keys

**Description:** Supporting nonclustered indexes to accelerate foreign key lookups across customer, order, employee, component, product, and warehouse relationships.

## Notes

- Indexes are created conditionally to avoid conflicts on existing environments.
*/

-- customers
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Customers_Demographics')
CREATE NONCLUSTERED INDEX [IX_Customers_Demographics] 
ON [Customers] ([CustomerDemographicsID]);
GO

-- orders table - linking to customers and employees
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Orders_CustomerID')
CREATE NONCLUSTERED INDEX [IX_Orders_CustomerID] 
ON [Orders] ([CustomerID]);
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Orders_DealerEmployeeID')
CREATE NONCLUSTERED INDEX [IX_Orders_DealerEmployeeID] 
ON [Orders] ([DealerEmployeeID]);
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Orders_AssemblerEmployeeID')
CREATE NONCLUSTERED INDEX [IX_Orders_AssemblerEmployeeID] 
ON [Orders] ([AssemblerEmployeeID]);
GO

-- order
-- note: OrderID is already the PK so it's indexed. just need ProductID
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_OrderDetails_ProductID')
CREATE NONCLUSTERED INDEX [IX_OrderDetails_ProductID] 
ON [OrderDetails] ([ProductID]);
GO

-- employees table
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Employees_Position')
CREATE NONCLUSTERED INDEX [IX_Employees_Position] 
ON [Employees] ([EmployeePositionID]);
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Employees_ReportsTo')
CREATE NONCLUSTERED INDEX [IX_Employees_ReportsTo] 
ON [Employees] ([ReportsTo]);
GO

-- components & inventory
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Components_Supplier')
CREATE NONCLUSTERED INDEX [IX_Components_Supplier] 
ON [Components] ([SupplierID]);
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_CompInventory_Component')
CREATE NONCLUSTERED INDEX [IX_CompInventory_Component] 
ON [ComponentsInventory] ([ComponentID]);
GO

-- products table
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Products_Supplier')
CREATE NONCLUSTERED INDEX [IX_Products_Supplier] 
ON [Products] ([SupplierID]);
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Products_Category')
CREATE NONCLUSTERED INDEX [IX_Products_Category] 
ON [Products] ([CategoryID]);
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Products_Recipes')
CREATE NONCLUSTERED INDEX [IX_Products_Recipes] 
ON [Products] ([ProductRecipesID]);
GO

-- warehouse
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Warehouse_ProductID')
CREATE NONCLUSTERED INDEX [IX_Warehouse_ProductID] 
ON [Warehouse] ([ProductID]);
GO

-- recipe ingredients
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_RecipeIngredients_Recipe')
CREATE NONCLUSTERED INDEX [IX_RecipeIngredients_Recipe] 
ON [RecipeIngredients] ([ProductRecipeID]);
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_RecipeIngredients_Component')
CREATE NONCLUSTERED INDEX [IX_RecipeIngredients_Component] 
ON [RecipeIngredients] ([ComponentID]);
GO
