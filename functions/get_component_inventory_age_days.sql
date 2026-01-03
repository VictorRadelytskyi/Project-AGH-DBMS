CREATE FUNCTION dbo.fn_GetComponentInventoryAgeDays (@ComponentID INT)
RETURNS INT
AS
BEGIN

    DECLARE @OldestStockDate DATETIME;

    SELECT @OldestStockDate = MIN(InventoryDate)
    FROM dbo.ComponentsInventory
    WHERE ComponentID = @ComponentID
      AND UnitsInStock > 0;

    IF @OldestStockDate IS NULL RETURN 0

    RETURN DATEDIFF(DAY, @OldestStockDate, GETDATE());

END;
GO