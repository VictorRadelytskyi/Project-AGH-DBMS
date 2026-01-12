/*
Sales indexes

**Description:** Supporting indexes for sales analytics and reporting.

## Indexes

- `IX_Orders_OrderDate_Include`: Covers \"Sales by Date\" reports by including `FulfillmentFinish` and `ID` to answer completion counts without table lookups.
- `IX_Customers_Region_City`: Accelerates \"Sales by Region\" analyses, especially filters by `Region` alone or by `Region` and `City`.
*/

CREATE NONCLUSTERED INDEX IX_Orders_OrderDate_Include
ON dbo.Orders (OrderDate)
INCLUDE (FulfillmentFinish, ID);
GO

CREATE NONCLUSTERED INDEX IX_Customers_Region_City
ON dbo.Customers (Region, City);
GO
