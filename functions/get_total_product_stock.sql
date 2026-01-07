/*
fn_GetTotalProductStock

Aggregates the current stock levels of a specific product 
across all warehouse locations defined in the system.
    
Logic:
1. Filters the Warehouse table for the specific ProductID provided.
2. Sum(UnitsInStock) to combine quantities from different shelves or sections.
3. Returns 0 if the product is not found or has no stock entries.

Usage:
SELECT dbo.fn_GetTotalProductStock(10) AS AvailableStock;

Note: Use this to check "Ready-to-Ship" inventory before 
processing new customer orders.
*/

CREATE FUNCTION dbo.fn_GetTotalProductStock (@ProductID INT) 
RETURNS INT 
AS 
BEGIN
    DECLARE @TotalUnits INT;

    SELECT @TotalUnits = SUM(UnitsInStock)
    FROM Warehouse
    WHERE ProductID = @ProductID;

    RETURN ISNULL(@TotalUnits, 0);
END;
GO
