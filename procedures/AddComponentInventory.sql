-- Procedura AddComponentInventory - dodawanie nowej dostawy danego komponentu do magazunu komponentów w bazie
CREATE PROCEDURE AddComponentInventory @componentID INT,
@inventoryDate DATETIME = NULL,
@unitPrice decimal(10,2),
@unitsInStock int,
@ID INT OUTPUT
AS 
BEGIN
SET NOCOUNT ON;

BEGIN TRY
    BEGIN TRAN AddComponentInv
        INSERT INTO
            ComponentsInventory (
                ComponentID,
                InventoryDate,
                UnitPrice,
                UnitsInStock
            )
            VALUES (
                @componentID,
                ISNULL(@inventoryDate, GETDATE()),
                @unitPrice,
                @unitsInStock
            )

        SET @ID = CAST(SCOPE_IDENTITY() AS INT);

    COMMIT TRAN AddComponentInv 
END TRY 
BEGIN CATCH 
    IF @@TRANCOUNT > 0
        ROLLBACK TRAN AddComponentInv 
    DECLARE @msg NVARCHAR(2048) = 'Nie udało się dodać komponentu do magazynu:' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
    THROW 52000, @msg, 1;

END CATCH
END;
GO