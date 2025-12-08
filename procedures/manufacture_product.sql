/*
sp_ManufactureProduct

Executes the production of a finished good using the BOM.
    
1. Looks up the Recipe for the Product.
2. Checks if ALL required components are in stock.
3. Deducts ALL required components from inventory.
4. Adds the finished good to the Warehouse.
    
Parameters:

@ProductID      - The ID of the product to manufacture
@Quantity       - How many units to produce
@TargetLocation - Warehouse location (e.g. 'Zone A')
    
Usage:

EXEC sp_ManufactureProduct 
	@ProductID = 1, 
	@Quantity = 50,
	@TargetLocation = 'Zone-A-Rack-1';
*/

CREATE OR ALTER PROCEDURE [dbo].[sp_ManufactureProduct]
    @ProductID INT,
    @Quantity INT,
    @TargetLocation VARCHAR(150)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @RecipeID INT;
    DECLARE @MissingComponent VARCHAR(255);

    -- Input Validation
    IF @Quantity <= 0 THROW 51000, 'Quantity must be greater than zero.', 1;

    BEGIN TRY
        -- Identify the Recipe
        SELECT @RecipeID = ProductRecipesID 
        FROM [dbo].[Products] 
        WHERE ID = @ProductID;

        IF @RecipeID IS NULL
            THROW 51000, 'Product not found or does not have a linked recipe.', 1;

        -- Do we have enough materials?
        SELECT TOP 1 @MissingComponent = c.ComponentName
        FROM [dbo].[RecipeIngredients] ri
        INNER JOIN [dbo].[Components] c ON ri.ComponentID = c.ID
        WHERE ri.ProductRecipeID = @RecipeID
          AND (ri.QuantityRequired * @Quantity) > c.UnitsInStock;

        -- found a missing item = halt execution 
        IF @MissingComponent IS NOT NULL
        BEGIN
            DECLARE @ErrorMsg NVARCHAR(2048) = FORMATMESSAGE('Insufficient stock for component: %s', @MissingComponent);
            THROW 51001, @ErrorMsg, 1;
        END

        BEGIN TRANSACTION;

            -- Deduct Raw Materials
            UPDATE c
            SET c.UnitsInStock = c.UnitsInStock - (ri.QuantityRequired * @Quantity)
            FROM [dbo].[Components] c
            INNER JOIN [dbo].[RecipeIngredients] ri ON c.ID = ri.ComponentID
            WHERE ri.ProductRecipeID = @RecipeID;

            -- Add Finished Good to Warehouse
            IF EXISTS (SELECT 1 FROM [dbo].[Warehouse] WHERE ProductID = @ProductID AND StockLocation = @TargetLocation)
            BEGIN
                UPDATE [dbo].[Warehouse]
                SET UnitsInStock = UnitsInStock + @Quantity,
                    LastStockUpdate = GETDATE()
                WHERE ProductID = @ProductID AND StockLocation = @TargetLocation;
            END
            ELSE
            BEGIN
                INSERT INTO [dbo].[Warehouse] (ProductID, UnitsInStock, StockLocation, LastStockUpdate)
                VALUES (@ProductID, @Quantity, @TargetLocation, GETDATE());
            END

        COMMIT TRANSACTION;

        PRINT 'Production successful. Inventory updated.';

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO
