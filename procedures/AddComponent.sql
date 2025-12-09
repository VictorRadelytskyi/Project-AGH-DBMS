-- Procedura AddComponent - dodawanie nowego komponentu do bazy
CREATE PROCEDURE AddComponent @supplierID INT,
@componentName varchar(255),
@componentType varchar(255),
@unitPrice decimal(10,2),
@unitsInStock int,
@ID INT OUTPUT
AS 
BEGIN
SET NOCOUNT ON;

BEGIN TRY
    BEGIN TRAN AddComponent
        INSERT INTO
            Components (
                SupplierID,
                ComponentName,
                ComponentType,
                UnitPrice,
                UnitsInStock
            )
            VALUES (
                @supplierID,
                @componentName,
                @componentType,
                @unitPrice,
                @unitsInStock,
            )

        SET @ID = CAST(SCOPE_IDENTITY() AS INT);

    COMMIT TRAN AddComponent 
END TRY 
BEGIN CATCH 
    IF @@TRANCOUNT > 0
        ROLLBACK TRAN AddComponent 
    DECLARE @msg NVARCHAR(2048) = 'Nie udało się dodać nowego komponentu:' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
    THROW 52000, @msg, 1;

END CATCH
END;
GO
