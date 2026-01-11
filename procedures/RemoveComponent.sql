/*
RemoveComponent

Removes a component definition from the database.
This procedure safely deletes a record from the Components table.
It includes specific error handling for Foreign Key violations,
preventing the deletion of components that are currently in use.

Parameters:

@ID - ID of the component to be removed

Usage:

EXEC RemoveComponent 
    @ID = 10;

*/

CREATE PROCEDURE RemoveComponent @ID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN RemoveComponent

        DELETE FROM Components
        WHERE ID = @ID;

        IF @@ROWCOUNT = 0
            THROW 51000, 'Nie znaleziono półproduktu o podanym ID.', 1;

        COMMIT TRAN RemoveComponent
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRAN RemoveComponent
        
        DECLARE @msg NVARCHAR(2048) = 'Nie udało się usunąć półproduktu:' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();

        IF ERROR_NUMBER() = 547
            SET @msg = 'Nie można usunąć komponentu, ponieważ jest on używany w innych tabelach.' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();

        THROW 52000, @msg, 1;
    END CATCH
END;
GO
