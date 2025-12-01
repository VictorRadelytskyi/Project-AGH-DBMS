-- Customer Net Sales in Period
-- Scalar function returning the net sales of a given customer in a given period
--
-- Usage:
--SELECT
--	dbo.fn_CustomerNetSalesInPeriod(1, '2023-01-01', '2023-12-31') AS NetSales2023;

-- Helper:
-- SELECT * FROM dbo.fn_CustomerOrdersInPeriod(3, '2023-01-01', '2023-12-31');


CREATE FUNCTION dbo.fn_CustomerNetSalesInPeriod (
	@CustomerID INT,
	@FromDate	DATE,
	@ToDate		DATE
)
RETURNS DECIMAL(18,2)
AS
BEGIN
	DECLARE @NetValue DECIMAL(18,2);

	SELECT
		@NetValue = SUM(od.UnitPrice * od.Quantity * (1 - od.Discount))
	FROM Orders o
	JOIN OrderDetails od
		ON od.OrderID = o.ID
	WHERE o.CustomerID = @CustomerID
		AND o.OrderDate >= @FromDate
		AND o.OrderDate < DATEADD(DAY, 1, @ToDate);

	RETURN ISNULL(@NetValue, 0);
END;
GO
