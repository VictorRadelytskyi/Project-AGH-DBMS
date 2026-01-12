/*
Prevent Premature Order Closure

**Description:** Prevents setting 'FulfillmentFinish' if there are associated OrderDetails where QuantityFulfilled < Quantity.
*/

CREATE OR ALTER TRIGGER [dbo].[TR_Orders_PreventPrematureClosure]
ON [dbo].[Orders]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if FulfillmentFinish was updated
    IF UPDATE(FulfillmentFinish)
    BEGIN
        -- Look for any order in the 'inserted' batch that is marked finished
        -- but still has unfulfilled items in OrderDetails
        IF EXISTS (
            SELECT 1
            FROM inserted i
            JOIN [dbo].[OrderDetails] od ON i.ID = od.OrderID
            WHERE i.FulfillmentFinish IS NOT NULL
              AND od.QuantityFulfilled < od.Quantity
        )
        BEGIN
            RAISERROR ('Cannot finish an order that has incomplete items.', 16, 1);
            ROLLBACK TRANSACTION;
        END
    END
END;
GO
