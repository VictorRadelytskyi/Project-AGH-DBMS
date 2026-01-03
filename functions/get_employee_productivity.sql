/*
fn_GetEmployeeProductivity

Retrieves the productivity factor associated with an employee's 
current job position. Defaults to 1.00 if not found.

Parameters:

@EmployeeID - ID of the employee

Usage:

SELECT dbo.fn_GetEmployeeProductivity(15) AS [EfficiencyFactor];

*/

CREATE FUNCTION dbo.fn_GetEmployeeProductivity (@EmployeeID INT)
RETURNS DECIMAL(4, 2)
AS
BEGIN

    DECLARE @Factor DECIMAL(4,2);

    SELECT @Factor = ep.ProductivityFactor
    FROM dbo.Employees e
    INNER JOIN dbo.EmployeePositions ep ON ep.ID = e.EmployeePositionID
    WHERE e.ID = @EmployeeID

    RETURN ISNULL(@Factor, 1.00)
    
END;
GO
