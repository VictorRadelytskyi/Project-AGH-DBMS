/*
UpdateProductRecipe

Updates an existing product recipe with new information.

Parameters:
@ID          - ID of the product recipe to update (required)
@RecipeName  - Name of the recipe
@LabourHours - Number of labor hours required (must be positive)

Business Rules:
- LabourHours must be greater than 0
- Product recipe with specified ID must exist
- Recipe name should be descriptive of the manufacturing process

Usage:
EXEC UpdateProductRecipe 
    @ID = 3,
    @RecipeName = 'Updated Assembly Process v2.1',
    @LabourHours = 4.5;

Error Handling:
- Throws error 51000 if LabourHours is not positive
- Throws error 51000 if recipe with specified ID doesn't exist
- Throws error 52000 for any other database errors
- All operations are wrapped in a transaction for data consistency
*/

CREATE PROCEDURE UpdateProductRecipe
@ID INT,
@RecipeName VARCHAR(255),
@LabourHours DECIMAL(10, 2)
AS 
BEGIN
SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRAN UpdateProductRecipe
        IF @LabourHours <= 0
        BEGIN 
            ROLLBACK TRAN UpdateProductRecipe;
            DECLARE @msg NVARCHAR(2048) = 'Godziny pracy powinny być dodatnie';
            THROW 51000, @msg, 1;
            RETURN;
        END 

        UPDATE ProductRecipes
        SET RecipeName = @RecipeName,
        LabourHours = @LabourHours
        WHERE ID = @ID
        
        IF @@Rowcount = 0
        BEGIN
            ROLLBACK TRAN UpdateProductRecipe;
            DECLARE @msg1 NVARCHAR(2048) = N'Nie udało się zaktualizować ProductRecipe' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
            THROW 51000, @msg1, 1;
            RETURN;
        END 

        COMMIT TRAN UpdateProductRecipe
END TRY
BEGIN CATCH
IF @@TRANCOUNT > 0
        ROLLBACK TRAN UpdateProductRecipe 
    DECLARE @msg2 NVARCHAR(2048) = 'Nie udało się zaktualizować ProductRecipe:' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
    THROW 52000, @msg2, 1;
END CATCH
END;
GO
