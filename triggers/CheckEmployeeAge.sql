/*
CheckEmployeeAge

Validates that employees are at least 18 years old at the time of hiring.
This trigger enforces legal employment age requirements.

Business Rules:
- All employees must be at least 18 years old
- BirthDate cannot be NULL
- Age is calculated as of the current date
- Violation blocks the INSERT/UPDATE operation

Trigger Type: AFTER INSERT, UPDATE
Table: Employees

Error Handling:
- Throws error 51000 if employee is under 18
- Throws error 51000 if BirthDate is NULL
- Rolls back the entire transaction on violation

Example Scenarios:
- Employee born 2008-01-01 in 2026 -> BLOCKED (under 18)
- Employee born 2000-01-01 in 2026 -> ALLOWED (26 years old)
- NULL BirthDate -> BLOCKED (required field)
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

