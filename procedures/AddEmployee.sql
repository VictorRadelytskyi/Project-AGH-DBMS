/*
AddEmployee

Adds a new employee record to the database.

Parameters:

@employeePositionID - ID of the job position (Foreign Key)
@firstName          - Employee's first name
@lastName           - Employee's last name
@birthDate          - Date of birth
@streetAddress      - Street and number
@city               - City
@region             - State/Province/Region
@postalCode         - Zip/Postal code
@country            - Country
@phoneNumber        - Contact phone number
@ID                 - OUTPUT. Returns the generated EmployeeID

Usage:

DECLARE @NewEmployeeID INT;

EXEC AddEmployee 
    @employeePositionID = 2,
    @firstName = '...',
    @lastName = '...',
    @birthDate = '1990-05-15',
    @streetAddress = '...',
    @city = '...',
    @region = '...',
    @postalCode = '...',
    @country = '...',
    @phoneNumber = '+48 123 456 789',
    @ID = @NewEmployeeID OUTPUT;

*/

CREATE PROCEDURE AddEmployee @employeePositionID int,
@firstName varchar(255),
@lastName varchar(255),
@birthDate date,
@streetAddress varchar(2000),
@city varchar(255),
@region varchar(255),
@postalCode varchar(16),
@country varchar(255),
@phoneNumber varchar(32),
@ID INT OUTPUT 
AS 
BEGIN
SET NOCOUNT ON;

BEGIN TRY
    BEGIN TRAN AddEmployee
        INSERT INTO
            Employees (
                EmployeePositionID,
                FirstName,
                LastName,
                BirthDate,
                StreetAddress,
                City,
                Region,
                PostalCode,
                Country,
                PhoneNumber
            )
        VALUES
            (
                @employeePositionID,
                @firstName,
                @lastName,
                @birthDate,
                @streetAddress,
                @city,
                @region,
                @postalCode,
                @country,
                @phoneNumber
            );

        SET @ID = CAST(SCOPE_IDENTITY() AS INT);

    COMMIT TRAN AddEmployee 
END TRY 
BEGIN CATCH 
    IF @@TRANCOUNT > 0
        ROLLBACK TRAN AddEmployee 
    DECLARE @msg NVARCHAR(2048) = 'Nie udało się dodać pracownika:' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
    THROW 52000, @msg, 1;

END CATCH
END;
GO