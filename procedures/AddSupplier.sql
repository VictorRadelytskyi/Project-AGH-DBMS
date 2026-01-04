/*
AddSupplier

Adds a new supplier record to the database.

Parameters:

@companyName   - Legal name of the supplier company
@contactName   - Primary contact person
@contactTitle  - Job title of the contact person
@streetAddress - Street and number
@city          - City
@region        - State/Province/Region
@postalCode    - Zip/Postal code
@country       - Country
@phoneNumber   - Contact phone number
@fax           - Fax number (Optional, defaults to NULL)
@ID            - OUTPUT. Returns the generated SupplierID

Usage:

DECLARE @NewSupplierID INT;

EXEC AddSupplier 
    @companyName = '...',
    @contactName = '...',
    @contactTitle = '...',
    @streetAddress = '...',
    @city = '...',
    @region = '...',
    @postalCode = '...',
    @country = '...',
    @phoneNumber = '...',
    @ID = @NewSupplierID OUTPUT;

*/

CREATE PROCEDURE AddSupplier @companyName varchar(255),
@contactName varchar(255),
@contactTitle varchar(255),
@streetAddress varchar(2000),
@city varchar(255),
@region varchar(255),
@postalCode varchar(16),
@country varchar(255),
@phoneNumber varchar(32),
@fax varchar(32) = NULL,
@ID INT OUTPUT
AS 
BEGIN
SET NOCOUNT ON;

BEGIN TRY
    BEGIN TRAN AddSupplier
        INSERT INTO
            Suppliers (
                CompanyName,
                ContactName,
                ContactTitle,
                StreetAddress,
                City,
                Region,
                PostalCode,
                Country,
                PhoneNumber,
                Fax
            )
            VALUES (
                @companyName,
                @contactName,
                @contactTitle,
                @streetAddress,
                @city,
                @region,
                @postalCode,
                @country,
                @phoneNumber,
                @fax
            )

        SET @ID = CAST(SCOPE_IDENTITY() AS INT);

    COMMIT TRAN AddSupplier 
END TRY 
BEGIN CATCH 
    IF @@TRANCOUNT > 0
        ROLLBACK TRAN AddSupplier 
    DECLARE @msg NVARCHAR(2048) = 'Nie udało się dodać nowego dostawcy:' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
    THROW 52000, @msg, 1;

END CATCH
END;
GO