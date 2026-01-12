/*
AddCategory

Adds a new product category to the system.

Parameters:
@CategoryName  - Name of the category (required, cannot be empty)
@Description   - Detailed description of the category (optional)
@Picture       - Binary image data for the category (optional)
@ID            - OUTPUT. Returns the generated CategoryID

Business Rules:
- CategoryName is required and cannot be empty or whitespace
- Description and Picture are optional
- CategoryName should be unique (enforced by database constraints)

Usage:
DECLARE @NewCategoryID INT;

EXEC AddCategory 
    @CategoryName = 'Electronics',
    @Description = 'Electronic components and devices',
    @Picture = NULL,
    @ID = @NewCategoryID OUTPUT;

SELECT @NewCategoryID AS [CreatedCategoryID];

Error Handling:
- Throws error 51001 if CategoryName is NULL or empty
- Throws error 51000 for any other database errors
- All operations are wrapped in a transaction for data consistency
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

