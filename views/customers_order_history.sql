-- Customer Order History View

-- Prints the order history grouped by customers and contacts.
-- Additional data include first and last order dates, order amounts, discounts, financial data.

CREATE VIEW vw_CustomerOrderHistory
AS
SELECT
	o.CustomerID,
	c.ContactName,
	MIN(o.OrderDate)												AS FirstOrderDate,
	MAX(o.OrderDate)												AS LastOrderDate,
--	DATEPART(YEAR,	o.OrderDate)										AS OrderYear,
--	DATEPART(MONTH,	o.OrderDate)										AS OrderMonth,
--	DATEPART(WEEK,	o.OrderDate)										AS OrderWeek,
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
	c.ContactName
--	DATEPART(YEAR,	o.OrderDate),
--	DATEPART(MONTH,	o.OrderDate),
--	DATEPART(WEEK,	o.OrderDate);
GO
