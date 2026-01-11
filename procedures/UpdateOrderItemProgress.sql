/*
UpdateOrderItemProgress

Updates the fulfillment status of a specific item in an order.

Checks performed:
	Prevents setting quantity < 0.
	Prevents setting quantity > Ordered Quantity.
	Ensures the order is actually in progress (Started but not Finished).

Parameters:
@OrderID   - The Order ID.
@ProductID - The Product ID being updated.
@NewQuantityFulfilled - The new total amount fulfilled (e.g., 3).
*/

CREATE OR ALTER PROCEDURE [dbo].[UpdateOrderItemProgress]
    @OrderID INT,
    @ProductID INT,
    @NewQuantityFulfilled SMALLINT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @MaxQuantity SMALLINT;
        DECLARE @FulfillmentStart DATETIME2(0);
        DECLARE @FulfillmentFinish DATETIME2(0);

        SELECT 
            @MaxQuantity = od.Quantity,
            @FulfillmentStart = o.FulfillmentStart,
            @FulfillmentFinish = o.FulfillmentFinish
        FROM [dbo].[OrderDetails] od
        JOIN [dbo].[Orders] o ON o.ID = od.OrderID
        WHERE od.OrderID = @OrderID AND od.ProductID = @ProductID;

        -- validation
        IF @MaxQuantity IS NULL
            THROW 50001, 'Item not found in this order.', 1;

        IF @FulfillmentStart IS NULL
            THROW 50002, 'Order has not been started yet. Run StartOrderFulfillment first.', 1;

        IF @FulfillmentFinish IS NOT NULL
            THROW 50003, 'Cannot modify items. Order is already finished.', 1;

        IF @NewQuantityFulfilled < 0
            THROW 50004, 'Quantity cannot be negative.', 1;

        IF @NewQuantityFulfilled > @MaxQuantity
        BEGIN
            DECLARE @Msg NVARCHAR(200) = FORMATMESSAGE('Cannot fulfill %d. Max quantity is %d.', @NewQuantityFulfilled, @MaxQuantity);
            THROW 50005, @Msg, 1;
        END

        -- update db 
        UPDATE [dbo].[OrderDetails]
        SET [QuantityFulfilled] = @NewQuantityFulfilled
        WHERE [OrderID] = @OrderID AND [ProductID] = @ProductID;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO
