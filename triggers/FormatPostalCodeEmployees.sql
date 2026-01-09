CREATE TRIGGER FormatPostalCode ON Employees
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
        ROLLBACK TRAN;
        THROW 51000, 'Kod pocztowy musi mieć co najmniej 5 znaków (po usunięciu spacji i myślników).', 1;

    UPDATE e
    SET PostalCode = REPLACE(REPLACE(i.PostalCode, '-', ''), ' ', '')
    FROM Employees e
    INNER JOIN inserted i ON e.ID = i.ID;
END;
GO
