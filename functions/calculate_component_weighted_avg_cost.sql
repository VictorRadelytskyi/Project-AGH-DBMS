CREATE FUNCTION dbo.fn_CalculateComponentWeightedAvgCost (@ComponentID INT)
RETURNS DECIMAL(10,2)
AS
BEGIN

    DECLARE @AvgCost DECIMAL(10,2);
    DECLARE @TotalCost DECIMAL(15,2);
    DECLARE @TotalQuantity INT;

    SELECT
        @TotalCost = SUM(UnitsInStock * UnitPrice),
        @TotalQuantity = SUM(UnitsInStock)
    FROM dbo.ComponentsInventory
    WHERE ComponentID = @ComponentID;

    IF @TotalQuantity > 0
        SET @AvgCost = @TotalCost / @TotalQuantity
    ELSE
        SELECT @AvgCost = UnitPrice
        FROM dbo.Components
        WHERE ID = @ComponentID;

    RETURN ISNULL(@AvgCost, 0.00);

END;
GO