/*
UpdateSupplier

Updates the contact and address information for an existing supplier.

Parameters:

@ID            - ID of the supplier to update
@companyName   - Legal name of the supplier company
@contactName   - Primary contact person
@contactTitle  - Job title of the contact person
@streetAddress - Street and number
@city          - City
@region        - State/Province/Region
@postalCode    - Zip/Postal code
@country       - Country
@phoneNumber   - Contact phone number
@fax           - Fax number

Usage:

EXEC UpdateSupplier 
    @ID = 1,
    @companyName = '...',
    @contactName = '...',
    @contactTitle = '...',
    @streetAddress = '...',
    @city = '...',
    @region = '...',
    @postalCode = '...',
    @country = '...',
    @phoneNumber = '...',
    @fax = NULL;

*/

CREATE PROCEDURE UpdateSupplier @ID INT,
@companyName varchar(255),
@contactName varchar(255),
@contactTitle varchar(255),
@streetAddress varchar(2000),
@city varchar(255),
@region varchar(255),
@postalCode varchar(16),
@country varchar(255),
@phoneNumber varchar(32),
@fax varchar(32)
AS 
BEGIN
SET NOCOUNT ON;

BEGIN TRY
    BEGIN TRAN UpdateSupplier

        UPDATE Suppliers
        SET CompanyName = @companyName,
        ContactName = @contactName,
        ContactTitle = @contactTitle,
        StreetAddress = @streetAddress,
        City = @city,
        Region = @region,
        PostalCode = @postalCode,
        Country = @country,
        PhoneNumber = @phoneNumber,
        Fax = @fax
        WHERE ID = @ID;

        IF @@ROWCOUNT = 0
            THROW 51000, 'Nie znaleziono dostawcy o podanym ID.', 1;


    COMMIT TRAN UpdateSupplier 
END TRY 
BEGIN CATCH 
    IF @@TRANCOUNT > 0
        ROLLBACK TRAN UpdateSupplier 
    DECLARE @msg NVARCHAR(2048) = 'Nie udało się zaktualizować danych dostawcy:' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
    THROW 52000, @msg, 1;

END CATCH
END;
GO
