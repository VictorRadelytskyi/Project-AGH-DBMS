/*
AddProductToWarehouse

**Description:** Adds stock for a product to the warehouse inventory and returns the warehouse record identifier.

## Parameters

- `@ProductID`: Product being stocked.
- `@UnitsInStock`: Quantity being added.
- `@StockLocation`: Warehouse location for the stock.
- `@ID`: Output parameter populated with the new warehouse record ID.

## Usage

```sql
EXEC AddProductToWarehouse
    @ProductID = 10,
    @UnitsInStock = 250,
    @StockLocation = 'A-03-02',
    @ID = @WarehouseRecordID OUTPUT;
```
*/

CREATE PROCEDURE AddProductToWarehouse
@ProductID INT NOT NULL,
@UnitsInStock INT NOT NULL,
@StockLocation VARCHAR(150) NOT NULL,
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
