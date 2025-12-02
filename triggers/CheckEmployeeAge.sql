CREATE TRIGGER CheckEmployeeAge ON Employees
FOR INSERT, UPDATE
AS
BEGIN

    SET NOCOUNT ON;

    IF TRIGGER_NESTLEVEL() > 1 RETURN;

    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE BirthDate > DATEDIFF(YEAR, -18, GETDATE())
    )
        ROLLBACK TRAN;
        THROW 51000, 'Nie można zatrudnić niepełnoletniego pracownika!!', 1;
    
END