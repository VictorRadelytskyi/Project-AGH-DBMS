/*
AddRecipeIngredient

Adds a component requirement to a product recipe, specifying how much
of a particular component is needed to manufacture the product.

Parameters:
@ProductRecipeID  - ID of the product recipe (required)
@ComponentID      - ID of the component needed (required)
@QuantityRequired - Amount of component needed (must be positive)
@ID               - OUTPUT. Returns the generated RecipeIngredientID

Business Rules:
- QuantityRequired must be greater than 0
- ProductRecipeID must reference an existing recipe
- ComponentID must reference an existing component
- Same component can appear multiple times in a recipe if needed

Usage:
DECLARE @NewIngredientID INT;

EXEC AddRecipeIngredient 
    @ProductRecipeID = 5,
    @ComponentID = 12,
    @QuantityRequired = 2.5,
    @ID = @NewIngredientID OUTPUT;

SELECT @NewIngredientID AS [CreatedRecipeIngredientID];

Error Handling:
- Throws error 52000 if QuantityRequired is not positive
- Throws error 51000 for foreign key violations or other database errors
- All operations are wrapped in a transaction for data consistency
*/

CREATE PROCEDURE AddRecipeIngredient
@ProductRecipeID INT,
@ComponentID INT,
@QuantityRequired DECIMAL(10, 2),
@ID INT OUTPUT
AS
BEGIN 
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN TRY
    BEGIN TRAN AddRecipeIngredient
        IF @QuantityRequired <= 0
            BEGIN 
                ROLLBACK TRAN AddRecipeIngredient
                DECLARE @msg NVARCHAR(2048) = N'ilość materiału nie może być ujemna' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
                THROW 52000, @msg, 1;
            END
    INSERT INTO RecipeIngredients(
        ProductRecipeID,
        ComponentID,
        QuantityRequired
    ) VALUES (
        @ProductRecipeID,
        @ComponentID,
        @QuantityRequired
    )
    
    SET @ID = CAST(SCOPE_IDENTITY() AS INT);
    COMMIT TRAN AddRecipeIngredient
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRAN AddRecipeIngredient
    IF @msg IS NULL
            SET @msg = N'Nie udało się dodać RecipeIngredient: ' + ERROR_MESSAGE();
        ELSE
            SET @msg = @msg + CHAR(13) + CHAR(10) + ERROR_MESSAGE();

    THROW 51000, @msg, 1;
END CATCH
END;
GO
