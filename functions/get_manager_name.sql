CREATE FUNCTION dbo.fn_GetManagerName (@EmployeeID INT)
RETURNS VARCHAR(512)
AS
BEGIN
    BEGIN TRY

        DECLARE @ManagerName VARCHAR(512);
        DECLARE @ManagerID INT;

        SELECT @ManagerID = ReportsTo
        FROM Employees
        WHERE ID = @EmployeeID;

        IF @ManagerID IS NOT NULL
            SET @ManagerName = dbo.fn_GetEmployeeFullName(@ManagerID);

    END TRY
    BEGIN CATCH

        DECLARE @msg NVARCHAR(2000);
        SET @msg = FORMATMESSAGE("Problem z pobraniem przełożonego pracownika o ID %d", @EmployeeID) + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
        THROW 52000, @msg, 1;
    
    END CATCH

    RETURN ISNULL(@ManagerName, "Brak przełożonego");
END;
GO