/*
fn_GetTotalComponentsInStock

Calculates the total quantity of a specific component currently held 
in inventory across all batches.

Parameters:

@ComponentID - ID of the component to aggregate

Usage:

SELECT dbo.fn_GetTotalComponentsInStock(10) AS [TotalUnitsAvailable];

*/

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

