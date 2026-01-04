/*
UpdateComponent

Updates the details of an existing component definition in the catalog.
This allows for modifying the name, type, linked supplier, or current 
catalog price of a specific component.

Parameters:

@ID            - ID of the component to update
@supplierID    - ID of the supplier providing this component
@componentName - New name of the component
@componentType - New category/type of the component
@unitPrice     - New catalog price per unit

Usage:

EXEC UpdateComponent 
    @ID = 10,
    @supplierID = 2,
    @componentName = '...',
    @componentType = 'Metal',
    @unitPrice = 0.15;

*/

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