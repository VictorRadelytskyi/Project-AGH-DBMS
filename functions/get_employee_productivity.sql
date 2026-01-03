CREATE FUNCTION dbo.fn_GetEmployeeProductivity (@EmployeeID INT)
RETURNS DECIMAL(4, 2)
AS
BEGIN
    BEGIN TRY

        DECLARE @Factor DECIMAL(4,2);

        SELECT @Factor = ep.ProductivityFactor
        FROM Employees e
        INNER JOIN EmployeePositions ep ON ep.ID = e.EmployeePositionID
        WHERE e.ID = @EmployeeID

    END TRY
    BEGIN CATCH

        DECLARE @msg NVARCHAR(2000);
        SET @msg = FORMATMESSAGE("Problem z pobraniem produktywności pracownika o ID %d", @EmployeeID) + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
        THROW 52000, @msg, 1;
    
    END CATCH

    RETURN ISNULL(@Factor, 1.00)
END;
GO
