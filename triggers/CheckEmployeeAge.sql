/*
CheckEmployeeAge

**Description:** Ensures that newly inserted or updated employees are at least 18 years old and have a birth date.

## Behavior

- Rolls back the transaction if `BirthDate` is missing or indicates an age under 18 years.
*/

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
