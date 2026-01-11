CREATE OR ALTER TRIGGER CheckReportsToEmployee ON Employees
AFTER INSERT, UPDATE
AS
BEGIN

    SET NOCOUNT ON;

    IF TRIGGER_NESTLEVEL() > 1 RETURN;

    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE ReportsTo IS NOT NULL
          AND ReportsTo = ID
    )
    BEGIN
        ROLLBACK TRAN;
        THROW 51000, 'Pracownik nie może być swoim własnym podwładnym!', 1;
    END;
    
END;
GO
