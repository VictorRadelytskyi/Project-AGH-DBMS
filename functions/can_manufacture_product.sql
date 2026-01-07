/*
fn_CheckIngredientsAvailable

Checks if the warehouse has enough raw components/materials to 
manufacture a specific quantity of a product based on its recipe.

Logic:
1. Identify all required components for the product via ProductRecipes.
2. For each ingredient, use CROSS APPLY to sum the total available 
   stock from ComponentsInventory (which may have multiple batches).
3. Compare: (Required Amount per Item * Target Quantity) vs. Total Stock.
4. Count how many ingredients fail this requirement.

Parameters:
@ProductID (INT)    - The product you want to build.
@QuantityToMake (INT) - How many units you intend to manufacture.

Returns:
BIT - 1 (Success/Enough Materials) if MissingIngredients = 0.
    - 0 (Failure/Shortage) if any ingredient is insufficient.

Usage:
IF dbo.fn_CanManufactureProduct(5, 50) = 1
    PRINT 'Production can start.';
ELSE
    PRINT 'Insufficient materials.';
*/

CREATE FUNCTION dbo.fn_CanManufactureProduct(
    @ProductID INT,
    @QuantityToMake INT
) RETURNS BIT
AS
BEGIN
    DECLARE @MissingComponents INT;
    SELECT @MissingComponents = COUNT(*)
    FROM RecipeIngredients ri
    JOIN Products p
    ON p.ProductRecipesID = ri.ProductRecipeID
    CROSS APPLY(
        SELECT SUM(UnitsInStock) AS TotalAvailable
        FROM ComponentsInventory ci
        WHERE ci.ComponentID = ri.ComponentID
    ) AS Inventory
    WHERE p.ID = @ProductID
    AND (ri.QuantityRequired * @QuantityToMake) > ISNULL(Inventory.TotalAvailable, 0);

    RETURN 
        CASE WHEN @MissingComponents = 0 
            THEN 1
        ELSE 0 
    END;
END;
GO