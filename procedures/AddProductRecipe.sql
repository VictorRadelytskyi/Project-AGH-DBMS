/*
AddProductRecipe

**Description:** Creates a new production recipe with its labor estimate and returns the generated recipe identifier.

## Parameters

- `@RecipeName`: Optional human-friendly recipe name.
- `@LabourHours`: Estimated labor hours required to produce one unit.
- `@ID`: Output parameter populated with the new recipe ID.

## Usage

```sql
EXEC AddProductRecipe
    @RecipeName = 'Widget Assembly',
    @LabourHours = 4.5,
    @ID = @NewRecipeID OUTPUT;
```
*/

CREATE PROCEDURE AddProductRecipe
@RecipeName VARCHAR(255),
@LabourHours DECIMAL(10, 2) NOT NULL,
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
