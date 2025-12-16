CREATE PROCEDURE UpdateCategory
@ID INT NOT NULL,
@CategoryName VARCHAR(250) NOT NULL, 
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
    DECLARE @msg NVARCHAR(2048) = 'Nie udało się zaktualizować danych kategorii:' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
    THROW 52000, @msg, 1;

END CATCH
END;
GO