/*
fn_GetEmployeeFullName

Returns the concatenated first and last name of an employee.

Parameters:

@EmployeeID - ID of the employee

Usage:

SELECT dbo.fn_GetEmployeeFullName(15) AS [EmployeeName];

*/

CREATE FUNCTION dbo.fn_GetEmployeeFullName (@EmployeeID INT)
RETURNS VARCHAR(512)
AS
BEGIN

    DECLARE @FullName VARCHAR(512);

    SELECT @FullName = e.FirstName + ' ' + e.LastName
    FROM dbo.Employees e
    WHERE e.ID = @EmployeeID;

    RETURN @FullName;
    
END;
GO

