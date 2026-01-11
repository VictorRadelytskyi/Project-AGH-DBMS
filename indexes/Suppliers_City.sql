/*
Speed up grouping suppliers by city for logistical purposes

*/

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Suppliers_City')
CREATE NONCLUSTERED INDEX IX_Suppliers_City
ON dbo.Suppliers (City);
GO
