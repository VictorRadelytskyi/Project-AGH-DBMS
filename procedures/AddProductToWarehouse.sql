/*
AddProductToWarehouse

Adds manufactured products to the warehouse inventory.
This procedure is typically used after production is completed 
to track finished goods ready for sale.

Parameters:

@ProductID     - ID of the product being stored (required)
@UnitsInStock  - Quantity of units being added to inventory (required)
@StockLocation - Physical location identifier (e.g., 'Aisle A, Shelf 3')
@ID            - OUTPUT. Returns the generated WarehouseID

Business Rules:
- ProductID must reference an existing product
- UnitsInStock should be positive (validation recommended)
- StockLocation helps with warehouse organization and picking
- LastStockUpdate is automatically set to current timestamp

Usage:

DECLARE @NewWarehouseID INT;

EXEC AddProductToWarehouse 
    @ProductID = 15,
    @UnitsInStock = 50,
    @StockLocation = 'Section B-12',
    @ID = @NewWarehouseID OUTPUT;

SELECT @NewWarehouseID AS [CreatedWarehouseRecordID];

Workflow:
1. Complete product manufacturing
2. Use this procedure to register finished goods in warehouse
3. Products become available for customer orders

Error Handling:
- Throws error 51000 for any database errors (foreign key violations, etc.)
- All operations are wrapped in a transaction for data consistency
*/

CREATE PROCEDURE AddProductToWarehouse
@ProductID INT,
@UnitsInStock INT,
@StockLocation VARCHAR(150),
@ID INT OUTPUT
AS
BEGIN
SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRAN AddProductToWarehouse
    INSERT INTO Warehouse(
        ProductID,
        UnitsInStock,
        StockLocation,
        LastStockUpdate
    ) VALUES (
        @ProductID,
        @UnitsInStock,
        @StockLocation,
        GETDATE()
    )
    SET @ID = CAST(SCOPE_IDENTITY() AS INT);
    COMMIT TRAN AddProductToWarehouse
END TRY
BEGIN CATCH 
    IF @@TRANCOUNT > 0
        ROLLBACK TRAN AddProductToWarehouse
        DECLARE @msg NVARCHAR (2048) = N'Nie udało się dodać produktu do Warehouse' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
        THROW 51000, @msg, 1;

END CATCH

END;
GO
