/*
UpdateCategory

Updates an existing product category with new information.

Parameters:
@ID           - ID of the category to update (required)
@CategoryName - Name of the category (required)
@Description  - Detailed description of the category (optional)
@Picture      - Binary image data for the category (optional)

Business Rules:
- Category with specified ID must exist
- CategoryName should be unique (enforced by database constraints)
- Description and Picture can be set to NULL to clear existing values

Usage:
EXEC UpdateCategory 
    @ID = 2,
    @CategoryName = 'Premium Electronics',
    @Description = 'High-end electronic components and luxury devices',
    @Picture = NULL;

Error Handling:
- Throws error 51000 if category with specified ID doesn't exist
- Throws error 52000 for any other database errors (e.g., constraint violations)
- All operations are wrapped in a transaction for data consistency
*/

CREATE PROCEDURE UpdateCategory
@ID INT,
@CategoryName VARCHAR(250), 
@Description VARCHAR(8000), 
@Picture VARBINARY(MAX)
AS
BEGIN
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN TRY
    BEGIN TRAN UpdateCategory
        UPDATE Categories
        SET CategoryName = @CategoryName,
        Description = @Description,
        Picture = @Picture
        WHERE ID = @ID
    IF @@Rowcount = 0
    BEGIN
        ROLLBACK TRAN UpdateCategory;
        DECLARE @msg NVARCHAR(2048) = N'Nie udało się zaktualizować kategorii' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
        THROW 51000, @msg, 1;
        RETURN;
    END 

    COMMIT TRAN UpdateCategory;

END TRY
BEGIN CATCH
IF @@TRANCOUNT > 0
        ROLLBACK TRAN UpdateCategory 
    DECLARE @warning NVARCHAR(2048) = 'Nie udało się zaktualizować danych kategorii:' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
    THROW 52000, @warning, 1;

END CATCH
END;
GO
