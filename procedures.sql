-- Procedura AddEmployee - dodawanie nowego pracownika do bazy
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

-- Procedura AddEmployeePosition - dodawanie nowego stanowiska do bazy
CREATE PROCEDURE AddEmployeePosition @positionName varchar(255),
@positionDescription varchar(max),
@productivityFactor decimal(4,2) = 1.0,
@ID INT OUTPUT
AS 
BEGIN
SET NOCOUNT ON;

BEGIN TRY
    BEGIN TRAN AddEmployeePosition
        INSERT INTO
            EmployeePositions (
                PositionName,
                PositionDescription,
                ProductivityFactor
            )
            VALUES (
                @positionName,
                @positionDescription,
                @productivityFactor
            )

        SET @ID = CAST(SCOPE_IDENTITY() AS INT);

    COMMIT TRAN AddEmployeePosition 
END TRY 
BEGIN CATCH 
    IF @@TRANCOUNT > 0
        ROLLBACK TRAN AddEmployeePosition 
    DECLARE @msg NVARCHAR(2048) = 'Nie udało się dodać nowego stanowiska:' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
    THROW 52000, @msg, 1;

END CATCH
END;
GO

-- Procedura UpdateEmployeePosition - aktualizacja danych istniejącego stanowiska w bazie
CREATE PROCEDURE UpdateEmployeePosition @ID INT,
@positionName varchar(255),
@positionDescription varchar(max),
@productivityFactor decimal(4,2) = 1.0
AS 
BEGIN
SET NOCOUNT ON;

BEGIN TRY
    BEGIN TRAN UpdateEmployeePosition

        UPDATE EmployeePositions
        SET PositionName = @positionName,
        PositionDescription = @positionDescription,
        ProductivityFactor = @productivityFactor
        WHERE ID = @ID;

        IF @@ROWCOUNT = 0
            THROW 51000, 'Nie znaleziono stanowiska o podanym ID.', 1;


    COMMIT TRAN UpdateEmployeePosition 
END TRY 
BEGIN CATCH 
    IF @@TRANCOUNT > 0
        ROLLBACK TRAN UpdateEmployeePosition 
    DECLARE @msg NVARCHAR(2048) = 'Nie udało się zaktualizować danych stanowiska:' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
    THROW 52000, @msg, 1;

END CATCH
END;
GO

-- Procedura AddSupplier - dodawanie nowego dostawcy do bazy
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

-- Procedura UpdateSupplier - aktualizacja danych istniejącego dostawcy w bazie
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

-- Procedura AddComponent - dodawanie nowego komponentu do bazy
CREATE PROCEDURE AddComponent @supplierID INT,
@componentName varchar(255),
@componentType varchar(255),
@unitPrice decimal(10,2),
@unitsInStock int,
@leadTime smallint = NULL,
@ID INT OUTPUT
AS 
BEGIN
SET NOCOUNT ON;

BEGIN TRY
    BEGIN TRAN AddComponent
        INSERT INTO
            Components (
                SupplierID,
                ComponentName,
                ComponentType,
                UnitPrice,
                UnitsInStock,
                LeadTime
            )
            VALUES (
                @supplierID,
                @componentName,
                @componentType,
                @unitPrice,
                @unitsInStock,
                @leadTime
            )

        SET @ID = CAST(SCOPE_IDENTITY() AS INT);

    COMMIT TRAN AddComponent 
END TRY 
BEGIN CATCH 
    IF @@TRANCOUNT > 0
        ROLLBACK TRAN AddComponent 
    DECLARE @msg NVARCHAR(2048) = 'Nie udało się dodać nowego komponentu:' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
    THROW 52000, @msg, 1;

END CATCH
END;
GO

-- Procedura UpdateComponent - aktualizacja danych istniejącego półproduktu w bazie
CREATE PROCEDURE UpdateComponent @ID INT,
@supplierID INT,
@componentName varchar(255),
@componentType varchar(255),
@unitPrice decimal(10,2),
@unitsInStock int,
@leadTime smallint
AS 
BEGIN
SET NOCOUNT ON;

BEGIN TRY
    BEGIN TRAN UpdateComponent

        UPDATE Components
        SET SupplierID = @supplierID,
        ComponentName = @componentName,
        ComponentType = @componentType,
        UnitPrice = @unitPrice,
        UnitsInStock = @unitsInStock,
        LeadTime = @leadTime
        WHERE ID = @ID;

        IF @@ROWCOUNT = 0
            THROW 51000, 'Nie znaleziono półproduktu o podanym ID.', 1;


    COMMIT TRAN UpdateComponent 
END TRY 
BEGIN CATCH 
    IF @@TRANCOUNT > 0
        ROLLBACK TRAN UpdateComponent 
    DECLARE @msg NVARCHAR(2048) = 'Nie udało się zaktualizować danych półproduktu:' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
    THROW 52000, @msg, 1;

END CATCH
END;
GO

CREATE PROCEDURE RemoveComponent @ID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN RemoveComponent

        DELETE FROM Components
        WHERE ID = @ID;

        IF @@ROWCOUNT = 0
            THROW 51000, 'Nie znaleziono półproduktu o podanym ID.', 1;

        COMMIT TRAN RemoveComponent
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRAN RemoveComponent
        
        DECLARE @msg NVARCHAR(2048) = 'Nie udało się usunąć półproduktu:' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();

        IF ERROR_NUMBER() = 547
            SET @msg = 'Nie można usunąć komponentu, ponieważ jest on używany w innych tabelach.' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();

        THROW 52000, @msg, 1;
    END CATCH
END;
GO