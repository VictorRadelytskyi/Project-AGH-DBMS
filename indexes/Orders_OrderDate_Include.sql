/*
"Sales by Date" reports.

Why use INCLUDE?
It adds the 'FulfillmentFinish' and 'ID' to the leaf nodes of the index. it allows the db to answer "How many orders were finished in May?" without even looking at the main table which should be brilliant for performance
*/
CREATE NONCLUSTERED INDEX IX_Orders_OrderDate_Include
ON dbo.Orders (OrderDate)
INCLUDE (FulfillmentFinish, ID);
GO

/*
"Sales by Region" analytics.

Filtering by Region will be fast
filtering by Region AND City will be very fast
*/
CREATE NONCLUSTERED INDEX IX_Customers_Region_City
ON dbo.Customers (Region, City);
GO
