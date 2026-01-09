/*
ConsumeComponentInventory

Reduces the stock level of a specific inventory batch by a given quantity.
This procedure targets a specific record by ID (e.g., a specific box or pallet).

It performs validation to ensure sufficient stock exists in the target batch
before applying the reduction.

Parameters:

@inventoryID       - ID of the specific inventory record (ComponentsInventory.ID)
@quantityToConsume - Amount of items to remove from this batch (Must be > 0)

Usage:

EXEC ConsumeComponentInventory 
    @inventoryID = 15, 
    @quantityToConsume = 50;

*/

CREATE PROCEDURE ConsumeComponentInventory 
    @inventoryID INT,
    @quantityToConsume INT
AS 
BEGIN
    SET NOCOUNT ON;

    IF @quantityToConsume <= 0
        THROW 51000, 'Ilość do pobrania musi być większa od zera.', 1;

    BEGIN TRY
        BEGIN TRAN ConsumeInv

            DECLARE @CurrentStock INT;
            
            SELECT @CurrentStock = UnitsInStock
            FROM ComponentsInventory WITH (UPDLOCK, ROWLOCK)
            WHERE ID = @inventoryID;

            IF @CurrentStock IS NULL
                THROW 51000, 'Nie znaleziono partii magazynowej o podanym ID.', 1;

            IF @CurrentStock < @quantityToConsume
            BEGIN
                DECLARE @msg NVARCHAR(200);
                SET @msg = FORMATMESSAGE('Niewystarczająca ilość towaru w partii %d. Dostępne: %d, Żądane: %d.', @inventoryID, @CurrentStock, @quantityToConsume);
                THROW 51000, @msg, 1;
            END

            UPDATE ComponentsInventory
            SET UnitsInStock = UnitsInStock - @quantityToConsume
            WHERE ID = @inventoryID;

        COMMIT TRAN ConsumeInv 
    END TRY 
    BEGIN CATCH 
        IF @@TRANCOUNT > 0
            ROLLBACK TRAN ConsumeInv;
            
        DECLARE @errorMsg NVARCHAR(2048) = 'Błąd podczas pobierania komponentu:' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
        THROW 52000, @errorMsg, 1;
    END CATCH
END;
GO
