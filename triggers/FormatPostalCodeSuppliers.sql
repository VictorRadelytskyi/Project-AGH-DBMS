/*
FormatPostalCodeSuppliers

**Description:** Validates and standardizes supplier postal codes after insert or update operations by stripping spaces and hyphens.

## Behavior

- Rejects records where cleaned postal codes are shorter than five characters.
- Updates stored postal codes to a compact, digit-only format.
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
