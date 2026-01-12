/*
StartOrderFulfillment

Marks an order as "In Progress".

- Validates that the order has not already started.
- Assigns the Assembler (employee) responsible for the work.
- Sets the fulfillmentStart timestamp to date of procedure execution.

Parameters:
@OrderID      - ID of the order to start.
@AssemblerID  - ID of the Employee performing the assembly.
*/

CREATE OR ALTER PROCEDURE dbo.StartOrderFulfillment
    @OrderID INT,
    @AssemblerID INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- validation 
        IF NOT EXISTS (SELECT 1 FROM dbo.Orders WHERE ID = @OrderID)
        BEGIN
            THROW 50001, 'Order not found.', 1;
        END

	-- validation check 2 (did fulfillment start already??)
        DECLARE @CurrentStart DATETIME2(0);
        SELECT @CurrentStart = FulfillmentStart 
        FROM dbo.Orders 
        WHERE ID = @OrderID;

        IF @CurrentStart IS NOT NULL
        BEGIN
            THROW 50002, 'Order fulfillment has already started.', 1;
        END

        -- everything good. insert data
        UPDATE dbo.Orders
        SET 
            FulfillmentStart = SYSDATETIME(),
            AssemblerEmployeeID = @AssemblerID
        WHERE ID = @OrderID;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO
