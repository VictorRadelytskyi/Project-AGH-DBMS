CREATE PROCEDURE AddRecipeIngredient
@ProductRecipeID INT NOT NULL,
@ComponentID INT NOT NULL,
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
        DECLARE @msg NVARCHAR(2048) = N'Nie udało się dodać RecipeIngredient' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
        THROW 51000, @msg, 1;
END CATCH
END;
GO
