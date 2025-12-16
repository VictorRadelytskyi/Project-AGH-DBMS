CREATE PROCEDURE UpdateProduct
@ID INT NOT NULL,
@SupplierID INT NOT NULL, 
@CategoryID INT NOT NULL, 
@ProductName VARCHAR(250) NOT NULL, 
@QuantityPerUnit INT NOT NULL, 
@UnitPrice DECIMAL(10, 2) NOT NULL, 
@ProductRecipesID INT NOT NULL,
@VATMultiplier DECIMAL(4,2) NOT NULL
AS 
BEGIN
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN TRY 
    BEGIN TRAN UpdateProduct
        IF @QuantityPerUnit <= 0 OR @UnitPrice <= 0 OR @VATMultiplier <=0
        BEGIN 
            ROLLBACK TRAN UpdateProduct;
            THROW 51000, N'QuantityPerUnit, UnitPrice oraz VATMultiplier powinny być dodatnie', 1;
            RETURN;
        END

        UPDATE Products
        SET SupplierID = @SupplierID,
        CategoryID = @CategoryID,
        ProductName = @ProductName,
        QuantityPerUnit = @QuantityPerUnit,
        UnitPrice = @UnitPrice,
        ProductRecipesID = @ProductRecipesID,
        VATMultiplier = @VATMultiplier
        WHERE ID = @ID

    IF @@ROWCOUNT = 0
    BEGIN 
        ROLLBACK TRAN UpdateProduct;
        DECLARE @msg NVARCHAR(2048) = N'nie znaleziono produktu od podanym ID' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
        THROW 51000, N'nie znaleziono produktu od podanym ID', 1;
        RETURN;
    END

    COMMIT TRAN UpdateProduct
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRAN UpdateProduct 
    DECLARE @msg NVARCHAR(2048) = 'Nie udało się zaktualizować danych produktu:' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
    THROW 52000, @msg, 1;
END CATCH
END;
GO