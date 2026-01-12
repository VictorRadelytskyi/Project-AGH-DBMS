/*
CheckReportsToEmployee

Prevents employees from being assigned as their own supervisor.
This trigger enforces proper organizational hierarchy rules.

Business Rules:
- An employee cannot report to themselves (ReportsTo ≠ ID)
- Maintains logical management structure
- Prevents circular reporting relationships

Trigger Type: AFTER INSERT, UPDATE
Table: Employees

Logic:
- Checks if any employee has ReportsTo = ID (self-reference)
- Uses TRIGGER_NESTLEVEL() > 1 to prevent infinite loops
- Blocks the operation if self-reporting is detected

Error Handling:
- Throws error 51000 if employee tries to report to themselves
- Rolls back the entire transaction on violation

Example Scenarios:
- Employee ID 5 with ReportsTo = 5 -> BLOCKED
- Employee ID 5 with ReportsTo = 3 -> ALLOWED
- Employee ID 5 with ReportsTo = NULL -> ALLOWED (no supervisor)
*/

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
