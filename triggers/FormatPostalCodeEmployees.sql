/*
FormatPostalCodeEmployees

Automatically formats and validates postal codes for employee records.
Removes spaces and dashes, then validates minimum length requirements.

Business Rules:
- Postal code must have at least 5 characters (after cleaning)
- Automatically removes spaces and dashes for consistency
- Updates the PostalCode field with cleaned format
- Maintains data consistency across all employee records

Trigger Type: AFTER INSERT, UPDATE
Table: Employees

Logic:
1. Removes all spaces and dashes from postal code
2. Validates that cleaned code has at least 5 characters
3. Updates the record with the standardized format
4. Uses TRIGGER_NESTLEVEL() to prevent infinite loops

Error Handling:
- Throws error 51000 if postal code too short after cleaning
- Rolls back transaction on validation failure

Example Transformations:
- '12-345' -> '12345' (ALLOWED - 5 chars)
- '12 345' -> '12345' (ALLOWED - 5 chars)
- '12-3' -> '123' (BLOCKED - only 3 chars)
- 'SW1A 1AA' -> 'SW1A1AA' (ALLOWED - 7 chars)
*/

CREATE OR ALTER TRIGGER FormatPostalCodeEmployees ON Employees
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF TRIGGER_NESTLEVEL() > 1 RETURN;

    IF EXISTS (
        SELECT 1 
        FROM inserted 
        WHERE LEN(REPLACE(REPLACE(PostalCode, '-', ''), ' ', '')) < 5
    )
    BEGIN
        ROLLBACK TRAN;
        THROW 51000, 'Kod pocztowy musi mieć co najmniej 5 znaków (po usunięciu spacji i myślników).', 1;
    END;

    UPDATE e
    SET PostalCode = REPLACE(REPLACE(i.PostalCode, '-', ''), ' ', '')
    FROM Employees e
    INNER JOIN inserted i ON e.ID = i.ID;
END;
GO
