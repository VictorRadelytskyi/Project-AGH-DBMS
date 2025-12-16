-- Procedura UpdateComponent - aktualizacja danych istniejącego półproduktu w bazie
CREATE PROCEDURE UpdateComponent @ID INT,
@supplierID INT,
@componentName varchar(255),
@componentType varchar(255),
@unitPrice decimal(10,2)
AS 
BEGIN
SET NOCOUNT ON;

BEGIN TRY
    BEGIN TRAN UpdateComponent

        UPDATE Components
        SET SupplierID = @supplierID,
        ComponentName = @componentName,
        ComponentType = @componentType,
        UnitPrice = @unitPrice
        WHERE ID = @ID;

        IF @@ROWCOUNT = 0
            THROW 51000, 'Nie znaleziono półproduktu o podanym ID.', 1;


    COMMIT TRAN UpdateComponent 
END TRY 
BEGIN CATCH 
    IF @@TRANCOUNT > 0
        ROLLBACK TRAN UpdateComponent 
    DECLARE @msg NVARCHAR(2048) = 'Nie udało się zaktualizować danych półproduktu:' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
    THROW 52000, @msg, 1;

END CATCH
END;
GO