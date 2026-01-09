CREATE PROCEDURE AddCategory
@CategoryName VARCHAR(250) NOT NULL, 
@Description VARCHAR(8000), 
@Picture VARBINARY(MAX),
@ID INT OUTPUT
AS 
BEGIN
SET NOCOUNT ON;
SET XACT_ABORT ON;

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

