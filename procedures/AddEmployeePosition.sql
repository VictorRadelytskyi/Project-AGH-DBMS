-- Procedura AddEmployeePosition - dodawanie nowego stanowiska do bazy
CREATE PROCEDURE AddEmployeePosition @positionName varchar(255),
@positionDescription varchar(max),
@productivityFactor decimal(4,2) = 1.0,
@ID INT OUTPUT
AS 
BEGIN
SET NOCOUNT ON;

BEGIN TRY
    BEGIN TRAN AddEmployeePosition
        INSERT INTO
            EmployeePositions (
                PositionName,
                PositionDescription,
                ProductivityFactor
            )
            VALUES (
                @positionName,
                @positionDescription,
                @productivityFactor
            )

        SET @ID = CAST(SCOPE_IDENTITY() AS INT);

    COMMIT TRAN AddEmployeePosition 
END TRY 
BEGIN CATCH 
    IF @@TRANCOUNT > 0
        ROLLBACK TRAN AddEmployeePosition 
    DECLARE @msg NVARCHAR(2048) = 'Nie udało się dodać nowego stanowiska:' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
    THROW 52000, @msg, 1;

END CATCH
END;
GO