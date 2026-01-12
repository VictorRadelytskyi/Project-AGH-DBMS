/*
AddCategory

**Description:** Creates a new product category and returns its generated identifier.

## Parameters

- `@CategoryName`: Name of the category to create.
- `@Description`: Optional category description.
- `@Picture`: Optional image associated with the category.
- `@ID`: Output parameter populated with the new category ID.

## Usage

```sql
EXEC AddCategory
    @CategoryName = 'Beverages',
    @Description = 'Hot and cold drinks',
    @Picture = NULL,
    @ID = @NewCategoryID OUTPUT;
```
*/

CREATE PROCEDURE AddCategory
@CategoryName VARCHAR(250), 
@Description VARCHAR(8000), 
@Picture VARBINARY(MAX),
@ID INT OUTPUT
AS 
BEGIN
SET NOCOUNT ON;
SET XACT_ABORT ON;

IF @CategoryName IS NULL OR LTRIM(RTRIM(@CategoryName)) = ''
THROW 51001, N'@CategoryName cannot be NULL/empty.', 1;

BEGIN TRY
    BEGIN TRAN AddCategory
        INSERT INTO Categories(
            CategoryName,
            Description,
            Picture
        ) VALUES (
            @CategoryName,
            @Description,
            @Picture
        )
        SET @ID = CAST(SCOPE_IDENTITY() AS INT);
    COMMIT TRAN AddCategory
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRAN AddCategory
        DECLARE @msg NVARCHAR(2048) = N'nie udało się dodać kategorii' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
        THROW 51000, @msg, 1;
END CATCH
END;
GO
