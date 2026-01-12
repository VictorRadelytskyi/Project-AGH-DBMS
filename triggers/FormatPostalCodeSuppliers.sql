/*
FormatPostalCodeSuppliers

Automatically formats and validates postal codes for supplier records.
Removes spaces and dashes, then validates minimum length requirements.

Business Rules:
- Postal code must have at least 5 characters (after cleaning)
- Automatically removes spaces and dashes for consistency
- Updates the PostalCode field with cleaned format
- Maintains data consistency across all supplier records

Trigger Type: AFTER INSERT, UPDATE
Table: Suppliers

Logic:
1. Removes all spaces and dashes from postal code
2. Validates that cleaned code has at least 5 characters
3. Updates the record with the standardized format
4. Uses TRIGGER_NESTLEVEL() to prevent infinite loops

Error Handling:
- Throws error 51000 if postal code too short after cleaning
- Validation failure prevents record creation/update

Example Transformations:
- '90210-1234' -> '902101234' (ALLOWED - 9 chars)
- 'M5V 3A8' -> 'M5V3A8' (ALLOWED - 6 chars)
- '12-34' -> '1234' (BLOCKED - only 4 chars)
- 'EC1A 1BB' -> 'EC1A1BB' (ALLOWED - 7 chars)
*/

CREATE OR ALTER TRIGGER FormatPostalCodeSuppliers ON Suppliers
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

    UPDATE s
    SET PostalCode = REPLACE(REPLACE(i.PostalCode, '-', ''), ' ', '')
    FROM Suppliers s
    INNER JOIN inserted i ON s.ID = i.ID;
END;
GO
