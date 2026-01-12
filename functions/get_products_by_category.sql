/*
fn_GetProductsByCategory

Returns a list of all products within a specific category along with 
their current total warehouse stock.
    
Logic:
1. Joins Products and Categories to filter results by the @CategoryID.
2. Uses a LEFT JOIN with Warehouse to include products that exist in the 
   catalog but are currently out of stock (UnitsInStock will show as 0).
3. Aggregates stock using SUM and handles NULLs with ISNULL.

Usage:
SELECT * FROM dbo.fn_GetProductsByCategory(3);

Note: This is a Table-Valued Function. It should be used in the FROM 
clause of a query, similar to a View or a Table.
*/

CREATE FUNCTION dbo.fn_GetProductsByCategory(@CategoryID INT)
RETURNS TABLE 
AS
RETURN (
    SELECT 
        p.ID,
        p.ProductName,
        p.UnitPrice,
        ISNULL(SUM(w.UnitsInStock), 0) AS TotalInStock
    FROM 
    Products p
    JOIN Categories c
    ON p.CategoryID = c.ID
    LEFT JOIN Warehouse w
    ON p.ID = w.ProductID
    WHERE c.ID = @CategoryID
    GROUP BY p.ID, p.ProductName, p.UnitPrice
);
GO