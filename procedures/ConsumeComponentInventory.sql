-- Procedura ConsumeComponentInventory - pobieranie określonej ilości towaru ze stanu magazynowego o danym ID
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
                THROW 51000, @Msg, 1;
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