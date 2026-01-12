/*
Customer Order History View

**Description:** Aggregates customer orders by month and year, including order counts, product counts, quantities, and discount statistics.

## Notes

- Exposes first and last order dates plus gross and discounted values per customer-period combination.
*/

CREATE VIEW vw_CustomerOrderHistory
AS
SELECT
	o.CustomerID,
	c.ContactName,
	MIN(o.OrderDate)												AS FirstOrderDate,
	MAX(o.OrderDate)												AS LastOrderDate,
	DATEPART(YEAR,	o.OrderDate)										AS OrderYear,
	DATEPART(MONTH,	o.OrderDate)										AS OrderMonth,
	COUNT(DISTINCT o.ID)												AS AmountOfOrders,
	COUNT(od.ProductID)													AS UniqueProductsOrdered,
	SUM(od.Quantity)													AS TotalUnitsOrdered,
	SUM(od.UnitPrice * od.Quantity)										AS GrossValue,
	SUM(od.UnitPrice * od.Quantity * (1 - od.Discount))					AS NetValueAfterDiscount,
	MIN(od.Discount)													AS MinDiscount,
	MAX(od.Discount)													AS MaxDiscount,
	AVG(od.Discount)													AS AvgDiscount
FROM Orders o
JOIN Customers c
	ON o.CustomerID = c.ID
LEFT JOIN OrderDetails od
	ON od.OrderID = o.ID
GROUP BY
	o.CustomerID,
	c.ContactName,
	DATEPART(YEAR,	o.OrderDate),
	DATEPART(MONTH,	o.OrderDate);
GO
