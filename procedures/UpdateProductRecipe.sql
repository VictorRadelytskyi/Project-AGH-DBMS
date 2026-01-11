CREATE PROCEDURE UpdateProductRecipe
@ID INT,
@RecipeName VARCHAR(255),
@LabourHours DECIMAL(10, 2) NOT NULL
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
            DECLARE @msg NVARCHAR(2048) = N'Nie udało się zaktualizować ProductRecipe' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
            THROW 51000, @msg, 1;
            RETURN;
        END 

        COMMIT TRAN UpdateProductRecipe
END TRY
BEGIN CATCH
IF @@TRANCOUNT > 0
        ROLLBACK TRAN UpdateProductRecipe 
    DECLARE @msg NVARCHAR(2048) = 'Nie udało się zaktualizować ProductRecipe:' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
    THROW 52000, @msg, 1;
END CATCH
END;
GO
