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
