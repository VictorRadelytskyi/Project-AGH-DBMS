/*
AddProductRecipe

Creates a new manufacturing recipe that defines the labor requirements
for producing a product. Components are added separately via AddRecipeIngredient.

Parameters:
@RecipeName  - Descriptive name for the recipe (required)
@LabourHours - Number of labor hours required (must be positive)
@ID          - OUTPUT. Returns the generated ProductRecipeID

Business Rules:
- LabourHours must be greater than 0
- RecipeName should be descriptive and unique for clarity
- After creating the recipe, use AddRecipeIngredient to specify components

Workflow:
1. Create ProductRecipe with this procedure
2. Add required components using AddRecipeIngredient
3. Assign recipe to products using AddProduct or UpdateProduct

Usage:
DECLARE @NewRecipeID INT;

EXEC AddProductRecipe 
    @RecipeName = 'Wooden Chair Assembly v1.0',
    @LabourHours = 3.5,
    @ID = @NewRecipeID OUTPUT;

SELECT @NewRecipeID AS [CreatedRecipeID];

-- Then add ingredients:
-- EXEC AddRecipeIngredient @ProductRecipeID = @NewRecipeID, @ComponentID = 1, @QuantityRequired = 4; -- Wood planks
-- EXEC AddRecipeIngredient @ProductRecipeID = @NewRecipeID, @ComponentID = 2, @QuantityRequired = 8; -- Screws

Error Handling:
- Throws error 51000 if LabourHours is not positive
- Throws error 51000 for any other database errors
- All operations are wrapped in a transaction for data consistency
*/

CREATE PROCEDURE AddProductRecipe
@RecipeName VARCHAR(255),
@LabourHours DECIMAL(10, 2),
@ID INT OUTPUT 
AS 
BEGIN
SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @msg NVARCHAR(2048);

BEGIN TRY
    BEGIN TRAN
        IF @LabourHours <= 0
		BEGIN 
			SET @msg = N'Czas pracy nie może być ujemny';
			THROW 51000, @msg, 1;
		END
        INSERT INTO ProductRecipes(
            RecipeName,
            LabourHours
        ) VALUES (
            @RecipeName,
            @LabourHours
        )

        SET @ID = CAST(SCOPE_IDENTITY() AS INT);
    COMMIT;
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0 ROLLBACK;
		SET @msg = N'Nie udało się dodać ProductRecipe' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
		THROW 51000, @msg, 1;
END CATCH
END;
GO

