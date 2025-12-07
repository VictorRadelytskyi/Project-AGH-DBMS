-- Procedura UpdateEmployeePosition - aktualizacja danych istniejącego stanowiska w bazie
CREATE PROCEDURE UpdateEmployeePosition @ID INT,
@positionName varchar(255),
@positionDescription varchar(max),
@productivityFactor decimal(4,2) = 1.0
AS 
BEGIN
SET NOCOUNT ON;

BEGIN TRY
    BEGIN TRAN UpdateEmployeePosition

        UPDATE EmployeePositions
        SET PositionName = @positionName,
        PositionDescription = @positionDescription,
        ProductivityFactor = @productivityFactor
        WHERE ID = @ID;

        IF @@ROWCOUNT = 0
            THROW 51000, 'Nie znaleziono stanowiska o podanym ID.', 1;


    COMMIT TRAN UpdateEmployeePosition 
END TRY 
BEGIN CATCH 
    IF @@TRANCOUNT > 0
        ROLLBACK TRAN UpdateEmployeePosition 
    DECLARE @msg NVARCHAR(2048) = 'Nie udało się zaktualizować danych stanowiska:' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
    THROW 52000, @msg, 1;

END CATCH
END;
GO