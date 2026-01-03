CREATE FUNCTION dbo.fn_GetTotalComponentsInStock (@ComponentID INT)
RETURNS INT
AS
BEGIN

    DECLARE @StockQuantity INT;

    SELECT @StockQuantity = SUM(UnitsInStock)
    FROM dbo.ComponentsInventory
    WHERE ComponentID = @ComponentID;

    RETURN ISNULL(@StockQuantity, 0);

END;
GO