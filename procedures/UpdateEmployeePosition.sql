/*
UpdateEmployeePosition

Updates the definition of an existing job position.

Parameters:

@ID                  - ID of the position to update
@positionName        - New name of the job position
@positionDescription - New description of responsibilities
@productivityFactor  - New efficiency multiplier (e.g., 1.10)

Usage:

EXEC UpdateEmployeePosition 
    @ID = 2,
    @positionName = '...',
    @positionDescription = '...',
    @productivityFactor = 1.50;

*/

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