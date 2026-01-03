CREATE FUNCTION dbo.fn_GetEmployeeFullName (@EmployeeID INT)
RETURNS VARCHAR(512)
AS
BEGIN

    DECLARE @FullName VARCHAR(512);

    SELECT @FullName = e.FirstName + ' ' + e.LastName
    FROM Employees e
    WHERE e.ID = @EmployeeID;

    RETURN @FullName;
    
END;
GO