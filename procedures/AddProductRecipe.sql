CREATE PROCEDURE AddProductRecipe
@RecipeName VARCHAR(255),
@LabourHours DECIMAL(10, 2) NOT NULL,
@ID INT OUTPUT 
AS 
BEGIN
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN TRY
    BEGIN TRAN AddProductRecipe
        IF @LabourHours <= 0
            BEGIN 
                ROLLBACK TRAN AddProductRecipe
                DECLARE @msg NVARCHAR(2048) = N'Czas pracy nie może być ujemny';
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

