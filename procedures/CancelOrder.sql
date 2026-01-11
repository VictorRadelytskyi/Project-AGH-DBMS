/*
CancelOrder

Safely removes an order and its details from the system:
                    
1. Checks if the Order exists.
2. Prevents cancellation if the Order is older than 48 hours
(assumes such orders are already processed/shipped).
3. Deletes OrderDetails first (Foreign Key requirement).
4. Deletes Orders header last.

Parameters:

@OrderID - The ID of the order to cancel.
    
Usage:

EXEC CancelOrder @OrderID = 10248;

*/

CREATE OR ALTER PROCEDURE [dbo].[CancelOrder]
    @OrderID INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @OrderDate DATETIME;
    DECLARE @FulfillmentStart DATETIME;

    BEGIN TRY
        -- Validation
        SELECT 
          @OrderDate = OrderDate,
          @FulfillmentStart = FulfillmentStart
        FROM [dbo].[Orders] 
        WHERE ID = @OrderID;

        -- Check if order exists
        IF @OrderDate IS NULL
        BEGIN
            THROW 51000, 'The Order ID provided does not exist.', 1;
        END

        -- Check business rule: Cannot cancel orders older than 48 hours
        IF DATEDIFF(HOUR, @OrderDate, GETDATE()) > 48
        BEGIN
            THROW 51001, 'Cannot cancel order. It is older than 48 hours and may have already shipped.', 1;
        END

        IF @FulfillmentStart IS NOT NULL
        BEGIN
          THROW 51002, 'Cannot cancel order — fulfillment has already begun.', 1;
        END
          
        BEGIN TRANSACTION;

            -- Delete the children (Lines)
            DELETE FROM [dbo].[OrderDetails]
            WHERE OrderID = @OrderID;

            -- Delete the parent (Header)
            DELETE FROM [dbo].[Orders]
            WHERE ID = @OrderID;

        COMMIT TRANSACTION;
        
        -- Return success message or status
        PRINT 'Order ' + CAST(@OrderID AS VARCHAR(10)) + ' was successfully cancelled.';

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        THROW;
    END CATCH
END;
GO
