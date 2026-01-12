/*
AddProduct

**Description:** Inserts a new product with supplier, category, pricing, and recipe details and returns its generated identifier.

## Parameters

- `@SupplierID`: Supplier providing the product.
- `@CategoryID`: Category the product belongs to.
- `@ProductName`: Name of the product.
- `@QuantityPerUnit`: Units contained in one package.
- `@UnitPrice`: Price per unit (net).
- `@ProductRecipesID`: Linked recipe describing production steps.
- `@VATMultiplier`: VAT multiplier applied to the product.
- `@ID`: Output parameter populated with the new product ID.

## Usage

```sql
EXEC AddProduct
    @SupplierID = 1,
    @CategoryID = 2,
    @ProductName = 'Custom Widget',
    @QuantityPerUnit = 10,
    @UnitPrice = 19.99,
    @ProductRecipesID = 3,
    @VATMultiplier = 1.23,
    @ID = @NewProductID OUTPUT;
```
*/

CREATE PROCEDURE AddProduct 
@SupplierID INT NOT NULL, 
@CategoryID INT NOT NULL, 
@ProductName VARCHAR(250) NOT NULL, 
@QuantityPerUnit INT NOT NULL, 
@UnitPrice DECIMAL(10, 2) NOT NULL, 
@ProductRecipesID INT NOT NULL,
@VATMultiplier DECIMAL(4,2) NOT NULL,
@ID INT OUTPUT
AS
BEGIN
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN TRY
    BEGIN TRAN AddProduct
        IF @UnitPrice <= 0 OR @VATMultiplier <= 0 OR @QuantityPerUnit <= 0 
        BEGIN
            ROLLBACK TRAN AddProduct; 
            THROW 51000, 'Cena jednostkowa, QuantityPerUnit oraz VATMultiplier musszą być dodatnie', 1;
            RETURN;
        END

        INSERT INTO Products(
            SupplierID,
            CategoryID,
            ProductName,
            QuantityPerUnit,
            UnitPrice,
            ProductRecipesID,
            VATMultiplier
        ) VALUES(
            @SupplierID,
            @CategoryID,
            @ProductName,
            @QuantityPerUnit,
            @UnitPrice,
            @ProductRecipesID,
            @VATMultiplier
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
