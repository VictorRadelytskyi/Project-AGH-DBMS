/*
CheckWarehouseLocation

Validates that StockLocation identifiers are strictly alphanumeric 
and follow the "Letter-First" rule.

Rules:
- First Character: Must be a letter (A-Z).
- Subsequent Characters: Can be letters or numbers, dashes, commas or spaces.
- Special characters except dashes or spaces: Prohibited.

Logic:
1. Rejects strings starting with 0-9 or symbols.
2. Rejects any string containing non-alphanumeric characters unless it's dash, comma, or space.

Usage Examples:
- 'A101'     -> SUCCESS
- 'Warehouse1' -> SUCCESS
- '101A'     -> FAIL (Starts with number)
*/

CREATE TRIGGER CheckWarehouseLocation ON Warehouse
AFTER
INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1 
        FROM inserted 
        -- reject locations that don't start with a letter
        WHERE StockLocation NOT LIKE '[A-Za-z]%'
        -- reject locations that contain special characters except space or dash
        OR StockLocation LIKE '%[^A-Za-z0-9 -,]%'
    )
    BEGIN 
        RAISERROR('Invalid Location format. Must start with a letter and contain only alphanumeric characters.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO
