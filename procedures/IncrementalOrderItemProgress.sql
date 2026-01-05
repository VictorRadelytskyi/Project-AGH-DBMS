/*
IncrementOrderItemProgress

Increments the fulfilled quantity by a delta (usually +1 or -1).
Useful for barcode scanner interfaces or simply executing the procedure each time a product is done for peace of mind and to keep the db as the most up-to-date single source of truth
*/

CREATE OR ALTER PROCEDURE dbo.IncrementOrderItemProgress
    @OrderID INT,
    @ProductID INT,
    @Delta SMALLINT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @CurrentFulfilled SMALLINT;
        DECLARE @MaxQuantity SMALLINT;
        
        SELECT 
            @CurrentFulfilled = QuantityFulfilled,
            @MaxQuantity = Quantity
        FROM dbo.OrderDetails WITH (UPDLOCK, ROWLOCK) -- rowlock żeby nie było race conditions. fajne to w sumie, chociaż nwm czy w transakcji ma sens bo polecenia w transakcji wg. mojej wiedzy i tak wykonują się wszystkie jednocześnie? ale może microsoft to zrąbał w jakiś sposób i trzeba się bawić w takie rzeczy
        WHERE OrderID = @OrderID AND ProductID = @ProductID;

        IF @MaxQuantity IS NULL
             THROW 50001, 'Item not found.', 1;

        DECLARE @NewValue INT = @CurrentFulfilled + @Delta;

        -- Validation 
        IF @NewValue < 0 OR @NewValue > @MaxQuantity
            THROW 50002, 'Operation would result in invalid quantity (less than 0 or more than ordered).', 1;

	-- finish
        UPDATE dbo.OrderDetails
        SET QuantityFulfilled = @NewValue
        WHERE OrderID = @OrderID AND ProductID = @ProductID;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO
