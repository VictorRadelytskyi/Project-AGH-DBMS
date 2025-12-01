-- Order Net Value
-- Scalar function returning the net value of a given order
--
-- Usage:
--SELECT dbo.fn_OrderNetValue(1) AS OrderNetValue;
-- (using `dbo.` to make sure you're executing the function in the correct DB)

CREATE FUNCTION fn_OrderNetValue (@OrderID INT)
RETURNS DECIMAL(18,2)
AS
BEGIN
	DECLARE @NetValue DECIMAL(18,2);

	SELECT
		@NetValue = SUM(od.UnitPrice * od.Quantity * (1 - od.Discount))
	FROM OrderDetails od
	WHERE od.OrderID = @OrderID;

	RETURN ISNULL(@NetValue, 0);
END;
GO
