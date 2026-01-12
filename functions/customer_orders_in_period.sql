/*
Customer Orders in Period

**Description:** Function returning a table of a given customers order in a given timeframe
*/

-- Usage:
--SELECT * FROM fn_CustomerOrdersInPeriod(3, '2023-01-01', '2023-12-31');


CREATE FUNCTION dbo.fn_CustomerOrdersInPeriod (
	@CustomerID	INT,
	@FromDate	DATE,
	@ToDate		DATE
)
RETURNS TABLE
AS
RETURN
(
	SELECT
		o.ID													AS OrderID,
		o.OrderDate,
		o.RequiredDate,
		o.Freight,
		COUNT(od.ProductID)										AS NumberOfUniqueProducts,
		SUM(od.Quantity)										AS TotalUnits,
		SUM(od.UnitPrice * od.Quantity)							AS GrossValue,
		SUM(od.UnitPrice * od.Quantity * (1 - od.Discount))		AS NetValueAfterDiscount,
		MIN(od.Discount)										AS MinDiscount,
		MAX(od.Discount)										AS MaxDiscount,
		AVG(od.Discount)										AS AvgDiscount
	FROM Orders o
	LEFT JOIN OrderDetails od
		ON od.OrderID = o.ID
	WHERE o.CustomerID = @CustomerID
		AND o.OrderDate >= @FromDate
		AND o.OrderDate < DATEADD(DAY, 1, @ToDate)
	GROUP BY
		o.ID,
		o.CustomerID,
		o.OrderDate,
		o.RequiredDate,
		o.Freight
);
GO
