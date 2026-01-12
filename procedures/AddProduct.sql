/*
AddProduct

Adds a new product to the catalog that can be manufactured and sold.

Parameters:
@SupplierID       - ID of the primary supplier (required)
@CategoryID       - ID of the product category (required)
@ProductName      - Name of the product (required)
@QuantityPerUnit  - Units per package (must be positive)
@UnitPrice        - Selling price per unit (must be positive)
@ProductRecipesID - ID of the manufacturing recipe (required)
@VATMultiplier    - VAT rate multiplier (must be positive, e.g., 1.20 for 20% VAT)
@ID               - OUTPUT. Returns the generated ProductID

Business Rules:
- All price and quantity values must be positive
- ProductRecipesID must reference an existing recipe
- SupplierID must reference an existing supplier
- CategoryID must reference an existing category
- VATMultiplier typically ranges from 1.0 (0% VAT) to 1.25 (25% VAT)

Workflow:
1. Ensure recipe exists (use AddProductRecipe + AddRecipeIngredient)
2. Ensure supplier and category exist
3. Add product with this procedure
4. Use AddProductToWarehouse to add initial stock

Usage:
DECLARE @NewProductID INT;

EXEC AddProduct 
    @SupplierID = 1,
    @CategoryID = 3,
    @ProductName = 'Handcrafted Wooden Chair',
    @QuantityPerUnit = 1,
    @UnitPrice = 149.99,
    @ProductRecipesID = 5,
    @VATMultiplier = 1.20,
    @ID = @NewProductID OUTPUT;

SELECT @NewProductID AS [CreatedProductID];

Error Handling:
- Throws error 51000 if any price/quantity values are not positive
- Throws error 51000 for foreign key violations or other database errors
- All operations are wrapped in a transaction for data consistency
*/

CREATE PROCEDURE AddProduct 
@SupplierID INT,
@CategoryID INT, 
@ProductName VARCHAR(250), 
@QuantityPerUnit INT, 
@UnitPrice DECIMAL(10, 2), 
@ProductRecipesID INT,
@VATMultiplier DECIMAL(4,2),
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
            VATMultipler
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
