/*
fn_CalculateComponentStock

Calculates the total quantity of a specific component
currently available in the inventory across all batches/shipments.
Designed as a high-performance inline table-valued helper function.

Logic:

1. Filter ComponentsInventory by the provided ComponentID
2. Sum the UnitsInStock column for all matching entries
3. Handle NULL values (return 0 if no inventory records exist)
4. Return the result as a single-column table (TotalStock)

Usage:
-- Standalone:
SELECT * FROM dbo.fn_CalculateComponentStock(10);

-- As a helper in a larger query:
SELECT c.ComponentName, s.TotalStock 
FROM Components c
CROSS APPLY dbo.fn_CalculateComponentStock(c.ID) s;
*/

CREATE FUNCTION dbo.fn_CalculateComponentStock (
    @ComponentID INT
)
RETURNS TABLE
AS
RETURN (
    SELECT ISNULL(SUM(UnitsInStock), 0) AS TotalStock
    FROM ComponentsInventory
    WHERE ComponentID = @ComponentID
);
GO