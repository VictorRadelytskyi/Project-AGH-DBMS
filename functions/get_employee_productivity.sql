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
