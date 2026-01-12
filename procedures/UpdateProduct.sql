/*
UpdateProduct

Updates an existing product record with new information.

Parameters:
@ID               - ID of the product to update (required)
@SupplierID       - ID of the supplier providing this product
@CategoryID       - ID of the product category
@ProductName      - Name of the product
@QuantityPerUnit  - Number of units per package (must be positive)
@UnitPrice        - Price per unit (must be positive)
@ProductRecipesID - ID of the manufacturing recipe
@VATMultiplier    - VAT rate multiplier (must be positive, e.g., 1.20 for 20% VAT)

Business Rules:
- QuantityPerUnit must be greater than 0
- UnitPrice must be greater than 0
- VATMultiplier must be greater than 0
- Product with specified ID must exist

Usage:
EXEC UpdateProduct 
    @ID = 5,
    @SupplierID = 2,
    @CategoryID = 1,
    @ProductName = 'Updated Product Name',
    @QuantityPerUnit = 10,
    @UnitPrice = 25.99,
    @ProductRecipesID = 3,
    @VATMultiplier = 1.23;

Error Handling:
- Throws error 51000 if validation fails (negative values)
- Throws error 51000 if product with specified ID doesn't exist
- Throws error 52000 for any other database errors
- All operations are wrapped in a transaction for data consistency
*/

CREATE PROCEDURE UpdateProduct
@ID INT,
@SupplierID INT, 
@CategoryID INT, 
@ProductName VARCHAR(250), 
@QuantityPerUnit INT, 
@UnitPrice DECIMAL(10, 2), 
@ProductRecipesID INT,
@VATMultiplier DECIMAL(4,2)
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
        VATMultipler = @VATMultiplier
        WHERE ID = @ID

    IF @@ROWCOUNT = 0
    BEGIN 
        ROLLBACK TRAN UpdateProduct;
        DECLARE @msg NVARCHAR(2048) = N'nie znaleziono produktu od podanym ID' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
        THROW 51000, @msg, 1;
        RETURN;
    END

    COMMIT TRAN UpdateProduct
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRAN UpdateProduct 
    DECLARE @warning NVARCHAR(2048) = 'Nie udało się zaktualizować danych produktu:' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
    THROW 52000, @warning, 1;
END CATCH
END;
GO
