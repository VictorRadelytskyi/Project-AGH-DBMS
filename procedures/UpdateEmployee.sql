-- Procedura UpdateEmployee - aktualizacja danych istniejącego pracownika w bazie
CREATE PROCEDURE UpdateEmployee @ID INT,
@employeePositionID int,
@firstName varchar(255),
@lastName varchar(255),
@birthDate date,
@streetAddress varchar(2000),
@city varchar(255),
@region varchar(255),
@postalCode varchar(16),
@country varchar(255),
@phoneNumber varchar(32),
@reportsTo int,
@photoBin varbinary(max)
AS 
BEGIN
SET NOCOUNT ON;

BEGIN TRY
    BEGIN TRAN UpdateEmployee

        UPDATE Employees
        SET EmployeePositionID = @employeePositionID,
        FirstName = @firstName,
        LastName = @lastName,
        BirthDate = @birthDate,
        StreetAddress = @streetAddress,
        City = @city,
        Region = @region,
        PostalCode = @postalCode,
        Country = @country,
        PhoneNumber = @phoneNumber,
        ReportsTo = @reportsTo,
        PhotoBin = @photoBin
        WHERE ID = @ID;

        IF @@ROWCOUNT = 0
            THROW 51000, 'Nie znaleziono pracownika o podanym ID.', 1;

    COMMIT TRAN UpdateEmployee 
END TRY 
BEGIN CATCH 
    IF @@TRANCOUNT > 0
        ROLLBACK TRAN UpdateEmployee 
    DECLARE @msg NVARCHAR(2048) = 'Nie udało się zaktualizować danych pracownika:' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
    THROW 52000, @msg, 1;

END CATCH
END;
GO