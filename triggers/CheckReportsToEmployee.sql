CREATE TRIGGER CheckReportsToEmployee ON Employees
FOR INSERT, UPDATE
AS
BEGIN

    SET NOCOUNT ON;

    IF TRIGGER_NESTLEVEL() > 1 RETURN;

    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE ReportsTo = ID
    )
        ROLLBACK TRAN;
        THROW 51000, 'Pracownik nie może być swoim własnym podwładnym!', 1;
    
END