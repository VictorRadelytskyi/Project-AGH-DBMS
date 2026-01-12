/*
CheckWarehouseLocation

**Description:** Validates that `StockLocation` identifiers start with a letter and only contain allowed characters.

## Rules

- First character must be a letter (`A-Z`).
- Remaining characters may be letters, numbers, dashes, commas, or spaces.
- All other special characters are rejected.

## Usage Examples

- `A101` → valid
- `Warehouse1` → valid
- `101A` → invalid (starts with number)
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
