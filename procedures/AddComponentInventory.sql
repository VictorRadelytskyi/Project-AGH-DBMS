/*
AddComponentInventory

Adds a new shipment/batch of a specific component to the inventory.
This tracks the specific purchase price and date for a batch of items,
allowing for FIFO/LIFO cost calculations later.

Parameters:

@componentID   - ID of the component definition (from Components table)
@inventoryDate - Date of receipt. If NULL, current date/time is used.
@unitPrice     - Purchase price per unit for this specific batch
@unitsInStock  - Quantity of items received in this shipment
@ID            - OUTPUT. Returns the generated InventoryID

Usage:

DECLARE @NewInventoryID INT;

EXEC AddComponentInventory 
    @componentID = 10, 
    @inventoryDate = '2023-10-27', 
    @unitPrice = 12.50,
    @unitsInStock = 100,
    @ID = @NewInventoryID OUTPUT;

*/

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