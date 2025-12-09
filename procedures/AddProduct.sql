CREATE PROCEDURE AddProduct 
@SupplierID INT NOT NULL, 
@CategoryID INT NOT NULL, 
@ProductName VARCHAR(250) NOT NULL, 
@QuantityPerUnit INT NOT NULL, 
@UnitPrice DECIMAL(10, 2) NOT NULL, 
@ProductRecipesID INT NOT NULL,
@ID INT OUTPUT
AS
BEGIN
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN TRY
    BEGIN TRAN AddProduct
        IF @UnitPrice <= 0
        BEGIN
            ROLLBACK TRAN AddProduct; 
            THROW 51000, 'Cena jednostkowa musi być większa niż zero.', 1;
            RETURN;
        END

        INSERT INTO Products(
            SupplierID,
            CategoryID,
            ProductName,
            QuantityPerUnit,
            UnitPrice,
            ProductRecipesID
        ) VALUES(
            @SupplierID,
            @CategoryID,
            @ProductName,
            @QuantityPerUnit,
            @UnitPrice,
            @ProductRecipesID
        )
        
        SET @ID = CAST(SCOPE_IDENTITY() AS INT);
    COMMIT TRAN AddProduct;
END TRY 
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRAN AddProduct
    DECLARE @msg NVARCHAR(2048) = N'Nie udało się dodać produktu' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
    THROW 51000, @msg, 1;
        
END CATCH
END;
GO