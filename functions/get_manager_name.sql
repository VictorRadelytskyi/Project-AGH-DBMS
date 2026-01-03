CREATE FUNCTION dbo.fn_GetManagerName (@EmployeeID INT)
RETURNS VARCHAR(512)
AS
BEGIN

    DECLARE @ManagerName VARCHAR(512);
    DECLARE @ManagerID INT;

    SELECT @ManagerID = ReportsTo
    FROM Employees
    WHERE ID = @EmployeeID;

    IF @ManagerID IS NOT NULL
        SET @ManagerName = dbo.fn_GetEmployeeFullName(@ManagerID);

    RETURN ISNULL(@ManagerName, 'Brak przełożonego');

END;
GO