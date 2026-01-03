CREATE FUNCTION dbo.fn_GetEmployeeFullName (@EmployeeID INT)
RETURNS VARCHAR(512)
AS
BEGIN
    BEGIN TRY

        DECLARE @FullName VARCHAR(512);

        SELECT @FullName = e.FirstName + ' ' + e.LastName
        FROM Employees e
        WHERE e.ID = @EmployeeID;

    END TRY
    BEGIN CATCH

        DECLARE @msg NVARCHAR(2000);
        SET @msg = FORMATMESSAGE("Problem z pobraniem nazwy pracownika o ID %d", @EmployeeID) + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
        THROW 52000, @msg, 1;

    END CATCH

    RETURN @FullName;
END;
GO