CREATE OR ALTER TRIGGER CheckEmployeeAge ON Employees
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @cutoff date = DATEADD(YEAR, -18, CONVERT(date, GETDATE()));

    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE i.BirthDate IS NULL
           OR i.BirthDate > @cutoff    -- younger than 18
    )
    BEGIN
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW 51000, N'Nie można zatrudnić niepełnoletniego pracownika!!', 1;
    END
END;

