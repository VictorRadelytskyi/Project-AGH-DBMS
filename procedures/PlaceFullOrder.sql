/*

PlaceFullOrder

Creates an Order header and associated OrderDetails lines 
in a single Atomic Transaction.
                    
It expects the items list in JSON format.
It fetches the current UnitPrice from the Products table 
to ensure pricing integrity.
    
Parameters:

@CustomerID - ID of the customer
@EmployeeID - ID of the employee processing the order
@Freight    - Shipping cost (default 0)
@ItemsJson  - JSON string of items. 

Format: '[{"ProductID": 1, "Quantity": 5}, ...]'
    
Usage:

EXEC PlaceFullOrder 
@CustomerID = 1, 
@EmployeeID = 2, 
@Freight = 15.50,
@ItemsJson = N'[{"ProductID": 10, "Quantity": 2}, {"ProductID": 12, "Quantity": 1}]';
*/

CREATE OR ALTER PROCEDURE [dbo].[PlaceFullOrder]
    @CustomerID INT,
    @EmployeeID INT,
    @Freight DECIMAL(10,2) = 0.00,
    @ItemsJson NVARCHAR(MAX) -- Pass items as a JSON array
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @NewOrderID INT;

    BEGIN TRY
        BEGIN TRANSACTION;

            -- 1. Insert the Order Header
            INSERT INTO [dbo].[Orders] (CustomerID, EmployeeID, OrderDate, Freight)
            VALUES (@CustomerID, @EmployeeID, GETDATE(), @Freight);

            -- Capture the newly created Order ID
            SET @NewOrderID = SCOPE_IDENTITY();

            -- 2. Insert the Order Details
            -- We parse the JSON and join with Products to get the REAL price.
            INSERT INTO [dbo].[OrderDetails] (OrderID, ProductID, UnitPrice, Quantity, Discount)
            SELECT 
                @NewOrderID, 
                j.ProductID, 
                p.UnitPrice, -- Use server-side price, not client-side :)
                j.Quantity,
                0.0 -- Default discount (handled by ApplyVolumeDiscount later)
            FROM OPENJSON(@ItemsJson) 
            WITH (
                ProductID INT, 
                Quantity SMALLINT
            ) AS j
            INNER JOIN [dbo].[Products] p ON j.ProductID = p.ID;

        COMMIT TRANSACTION;

        -- 3. Return the ID of the new order to the application
        SELECT @NewOrderID AS [CreatedOrderID];

    END TRY
    BEGIN CATCH
        -- If anything failed (e.g., ProductID didn't exist), rollback everything
        IF @@TRANCOUNT > 0 
            ROLLBACK TRANSACTION;
        
        THROW;
    END CATCH
END;
GO
