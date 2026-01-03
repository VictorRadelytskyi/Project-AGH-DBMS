CREATE FUNCTION dbo.fn_CalculateSupplierTotalStockValue (@SupplierID INT)
RETURNS DECIMAL(15,2)
AS
BEGIN

    DECLARE @TotalValue DECIMAL(15,2);

    SELECT @TotalValue = SUM(ci.UnitsInStock * ci.UnitPrice)
    FROM dbo.ComponentsInventory ci
    INNER JOIN dbo.Components c ON c.ID = ci.ComponentID
    WHERE c.SupplierID = @SupplierID;

    RETURN ISNULL(@TotalValue, 0.00);

END;
GO