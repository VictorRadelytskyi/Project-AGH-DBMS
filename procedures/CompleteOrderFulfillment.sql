/*
CompleteOrderFulfillment

**Description:** Finalizes order fulfillment by setting the `FulfillmentFinish` timestamp after ensuring the order is complete.

## Checks performed

- Order must exist.
- Fulfillment must have started (`FulfillmentStart` is not null).
- Order must not already be finished (idempotency check).
- All order items must be fully fulfilled (`QuantityFulfilled == Quantity`).

## Parameters

- `@OrderID`: ID of the order to finalize.
*/

CREATE OR ALTER PROCEDURE [dbo].[CompleteOrderFulfillment]
    @OrderID INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Retrieve current order state
        DECLARE @FulfillmentStart DATETIME2(0);
        DECLARE @FulfillmentFinish DATETIME2(0);

        SELECT 
            @FulfillmentStart = [FulfillmentStart],
            @FulfillmentFinish = [FulfillmentFinish]
        FROM [dbo].[Orders]
        WHERE [ID] = @OrderID;

        -- check if the order exists
        IF @@ROWCOUNT = 0
            THROW 50001, 'Order with the provided ID does not exist.', 1;

        -- Ensure the order fulfillment has actually started
        IF @FulfillmentStart IS NULL
            THROW 50002, 'Cannot finish an order that has not started yet (FulfillmentStart is NULL).', 1;

        -- Ensure the order is not already finished to prevent overwriting the timestamp
        IF @FulfillmentFinish IS NOT NULL
        BEGIN
            -- Throw an error to inform the client that this action was redundant
            THROW 50003, 'Order has already been finished.', 1;
        END

        -- Verify that all items are fulfilled
        -- Checks for any line item where fulfilled quantity is less than required quantity
        IF EXISTS (
            SELECT 1 
            FROM [dbo].[OrderDetails]
            WHERE [OrderID] = @OrderID 
              AND [QuantityFulfilled] < [Quantity]
        )
        BEGIN
            THROW 50004, 'Cannot close order. There are unfulfilled items (QuantityFulfilled < Quantity).', 1;
        END

        -- Update the order status by setting the completion timestamp
        UPDATE [dbo].[Orders]
        SET [FulfillmentFinish] = SYSDATETIME()
        WHERE [ID] = @OrderID;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO
