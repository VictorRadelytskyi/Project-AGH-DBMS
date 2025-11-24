CREATE TABLE [Customers] (
	[ID] INTEGER NOT NULL IDENTITY UNIQUE,
	[CustomerDemographicsID] INTEGER,
	[ContactName] VARCHAR(255) NOT NULL,
	[ContactTitle] VARCHAR(255),
	[Address] TEXT(65535) NOT NULL,
	[City] VARCHAR(255) NOT NULL,
	[Region] VARCHAR(255) NOT NULL,
	[PostalCode] VARCHAR(16) NOT NULL,
	[Country] VARCHAR(255) NOT NULL,
	[PhoneNumber] VARCHAR(32) NOT NULL,
	[Fax] VARCHAR(32),
	PRIMARY KEY([ID])
);
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Lista klientów',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Customers';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Imię osoby kontaktowej u danego klienta',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Customers',
    @level2type=N'COLUMN',@level2name=N'ContactName';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Tytuł osoby kontaktowej',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Customers',
    @level2type=N'COLUMN',@level2name=N'ContactTitle';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Adres klienta do wysyłek i rozliczeń',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Customers',
    @level2type=N'COLUMN',@level2name=N'Address';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Miasto, w którym znajduje się adres klienta do wysyłek i rozliczeń',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Customers',
    @level2type=N'COLUMN',@level2name=N'City';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Region (województwo, Land...), w którym znajduje się adres klienta do wysyłek i rozliczeń',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Customers',
    @level2type=N'COLUMN',@level2name=N'Region';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Kod pocztowy, w którym znajduje się adres klienta do wysyłek i rozliczeń',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Customers',
    @level2type=N'COLUMN',@level2name=N'PostalCode';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Kraj, w którym znajduje się adres klienta do wysyłek i rozliczeń',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Customers',
    @level2type=N'COLUMN',@level2name=N'Country';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Numer telefonu do osoby kontaktowej u klienta',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Customers',
    @level2type=N'COLUMN',@level2name=N'PhoneNumber';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Numer faksu klienta',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Customers',
    @level2type=N'COLUMN',@level2name=N'Fax';
GO

CREATE TABLE [CustomerDemographics] (
	[ID] INTEGER NOT NULL IDENTITY UNIQUE,
	[AgeGroup] TINYINT,
	[HasChildren] BIT,
	[IncomeGroup] TINYINT,
	[IsCityResident] BIT,
	PRIMARY KEY([ID])
);
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Dane demograficzne o klientach',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'CustomerDemographics';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Zakodowana grupa wiekowa, np. 1=18–24, 2=25–34, ...',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'CustomerDemographics',
    @level2type=N'COLUMN',@level2name=N'AgeGroup';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Czy ma dzieci',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'CustomerDemographics',
    @level2type=N'COLUMN',@level2name=N'HasChildren';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Zakodowana grupa dochodów. Np.: 1 = niskie, 2 = średnie, 3 = wysokie',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'CustomerDemographics',
    @level2type=N'COLUMN',@level2name=N'IncomeGroup';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Czy jest mieszkańcem miasta',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'CustomerDemographics',
    @level2type=N'COLUMN',@level2name=N'IsCityResident';
GO

CREATE TABLE [Orders] (
	[ID] INTEGER NOT NULL IDENTITY UNIQUE,
	[CustomerID] INTEGER NOT NULL,
	[EmployeeID] INTEGER NOT NULL,
	[OrderDate] DATE NOT NULL,
	[RequiredDate] DATE,
	[Freight] DECIMAL(10,2) NOT NULL CHECK([Freight] >= 0.00),
	PRIMARY KEY([ID])
);
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Lista zamówień',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Orders';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Data złożenia zamówienia.  Można zmienić na DATETIME2 jeśli dokładna godzina jest potrzebna ',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Orders',
    @level2type=N'COLUMN',@level2name=N'OrderDate';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Data, do której zamówienie musi zostać zrealizowane.',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Orders',
    @level2type=N'COLUMN',@level2name=N'RequiredDate';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Koszt wysyłki.  DECIMAL ma bardziej przewidywalne zachowanie niż MONEY.',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Orders',
    @level2type=N'COLUMN',@level2name=N'Freight';
GO

CREATE TABLE [OrderDetails] (
	[OrderID] INTEGER NOT NULL IDENTITY UNIQUE,
	[ProductID] INTEGER NOT NULL,
	[UnitPrice] DECIMAL(10,2) NOT NULL CHECK([UnitPrice] >= 0.00),
	[Quantity] SMALLINT NOT NULL CHECK([Quantity] > 0),
	[Discount] DECIMAL(5,4) NOT NULL CHECK([Discount] BETWEEN 0 AND 1),
	PRIMARY KEY([OrderID], [ProductID])
);
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Szczegóły zamówienia',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'OrderDetails';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Cena jednostkowa produktu',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'OrderDetails',
    @level2type=N'COLUMN',@level2name=N'UnitPrice';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Liczba produktów w zamówieniu',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'OrderDetails',
    @level2type=N'COLUMN',@level2name=N'Quantity';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Rabat.  Np. 0.05 = 5% rabatu',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'OrderDetails',
    @level2type=N'COLUMN',@level2name=N'Discount';
GO

CREATE TABLE [EmployeePositions] (
	[ID] INT NOT NULL IDENTITY PRIMARY KEY,
    [PositionName] VARCHAR(255) NOT NULL,
    [PositionDescription] VARCHAR(MAX) NOT NULL,
    [ProductivityFactor] DECIMAL(4,2) NOT NULL DEFAULT 1.00 CHECK([ProductivityFactor] BETWEEN 0 AND 10)
);
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Lista stanowisk pracowników',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'EmployeePositions';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Nazwa danego stanowiska',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'EmployeePositions',
    @level2type=N'COLUMN',@level2name=N'PositionName';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Słowny opis danego stanowiska',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'EmployeePositions',
    @level2type=N'COLUMN',@level2name=N'PositionDescription';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Dla pracowników produkujących meble, mnożnik określający jak dużo osoba na danym stanowisku jest w stanie wyprodukować w każdej jednostce czasu. Domyślnie = 1',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'EmployeePositions',
    @level2type=N'COLUMN',@level2name=N'ProductivityFactor';
GO

CREATE TABLE [Employees] (
	[ID] INT NOT NULL IDENTITY PRIMARY KEY,
    [EmployeePositionID] INT,
    [FirstName] VARCHAR(255) NOT NULL,
    [LastName] VARCHAR(255) NOT NULL,
    [BirthDate] DATE NOT NULL,
    [StreetAddress] VARCHAR(2000) NOT NULL,
    [City] VARCHAR(255) NOT NULL,
    [Region] VARCHAR(255) NOT NULL,
    [PostalCode] VARCHAR(16) NOT NULL,
    [Country] VARCHAR(255) NOT NULL,
    [PhoneNumber] VARCHAR(32) NOT NULL,
    [ReportsTo] INT,
    [PhotoBin] VARBINARY(MAX),
	CONSTRAINT [FK_Employees_ReportsTo] FOREIGN KEY ([ReportsTo]) REFERENCES [Employees]([ID]),
    CONSTRAINT [FK_Employees_EmployeePositionID] FOREIGN KEY ([EmployeePositionID]) REFERENCES [EmployeePositions]([ID])
);
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Lista pracowników',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Employees';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Klucz obcy wskazujący na jakim stanowisku zatrudniony jest pracownik',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Employees',
    @level2type=N'COLUMN',@level2name=N'EmployeePositionID';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Imię pracownika',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Employees',
    @level2type=N'COLUMN',@level2name=N'FirstName';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Nazwisko pracownika',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Employees',
    @level2type=N'COLUMN',@level2name=N'LastName';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Data urodzenia - z niej również można wyliczyć obecny wiek pracownika',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Employees',
    @level2type=N'COLUMN',@level2name=N'BirthDate';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Ulica i numer domu / mieszkania adresu pracownika',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Employees',
    @level2type=N'COLUMN',@level2name=N'StreetAddress';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Nazwa miasta, w którym znajduje się adres danego pracownika',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Employees',
    @level2type=N'COLUMN',@level2name=N'City';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Nazwa regionu (województwa, etc.), w którym znajduje się adres danego pracownika',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Employees',
    @level2type=N'COLUMN',@level2name=N'Region';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Kod pocztowy właściwy dla adresu danego pracownika',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Employees',
    @level2type=N'COLUMN',@level2name=N'PostalCode';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Kraj, w którym znajduje się adres danego pracownika',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Employees',
    @level2type=N'COLUMN',@level2name=N'Country';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Numer telefonu pracownika',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Employees',
    @level2type=N'COLUMN',@level2name=N'PhoneNumber';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'ID pracownika, który jest przełożonym danego pracownika',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Employees',
    @level2type=N'COLUMN',@level2name=N'ReportsTo';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Fotografia pracownika w formacie binarnym',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Employees',
    @level2type=N'COLUMN',@level2name=N'PhotoBin';
GO

CREATE TABLE [Suppliers] (
    [ID] INT NOT NULL IDENTITY PRIMARY KEY,
    [CompanyName] VARCHAR(255) NOT NULL, 
    [ContactName] VARCHAR(255) NOT NULL, 
    [ContactTitle] VARCHAR(255), 
    [StreetAddress] VARCHAR(2000) NOT NULL,
    [City] VARCHAR(255) NOT NULL,
    [Region] VARCHAR(255) NOT NULL,
    [PostalCode] VARCHAR(16) NOT NULL,
    [Country] VARCHAR(255) NOT NULL,
    [PhoneNumber] VARCHAR(32) NOT NULL,
	[Fax] VARCHAR(32)
);
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Lista dostawców komponentów do produkcji mebli',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Suppliers';
GO


EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Nazwa firmy dostawcy',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Suppliers',
    @level2type=N'COLUMN',@level2name=N'CompanyName';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Imię i nazwisko osoby kontaktowej w firmie dostawcy',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Suppliers',
    @level2type=N'COLUMN',@level2name=N'ContactName';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Zwrot grzecznościowy osoby do kontaktu w firmie dostawcy',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Suppliers',
    @level2type=N'COLUMN',@level2name=N'ContactTitle';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Ulica i numer domu / mieszkania adresu dostawcy',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Suppliers',
    @level2type=N'COLUMN',@level2name=N'StreetAddress';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Nazwa miasta w którym znajduje się adres dostawcy',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Suppliers',
    @level2type=N'COLUMN',@level2name=N'City';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Nazwa regionu (województwo, etc.) w którym znajduje się adres dostawcy',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Suppliers',
    @level2type=N'COLUMN',@level2name=N'Region';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Kod pocztowy adresu dostawcy',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Suppliers',
    @level2type=N'COLUMN',@level2name=N'PostalCode';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Nazwa kraju w którym znajduje się adres dostawcy',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Suppliers',
    @level2type=N'COLUMN',@level2name=N'Country';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Numer telefonu dostawcy',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Suppliers',
    @level2type=N'COLUMN',@level2name=N'PhoneNumber';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Numer fax dostawcy',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Suppliers',
    @level2type=N'COLUMN',@level2name=N'Fax';
GO

CREATE TABLE [Components] (
    [ID] INT NOT NULL IDENTITY PRIMARY KEY,
    [SupplierID] INT,
    [ComponentName] VARCHAR(255) NOT NULL,
    [ComponentType] VARCHAR(255) NOT NULL,
    [UnitPrice] DECIMAL(10,2) NOT NULL CHECK([UnitPrice] >= 0.00),
    [UnitsInStock] INT NOT NULL DEFAULT 0 CHECK([UnitsInStock] >= 0), 
    [LeadTime] SMALLINT DEFAULT -1 CHECK([LeadTime] >= 0 OR [LeadTime] = -1),
    CONSTRAINT [FK_Components_SupplierID] FOREIGN KEY ([SupplierID]) REFERENCES [Suppliers]([ID])
);
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Lista komponentów (półproduktów) używanych do produkcji',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Components';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Klucz obcy wskazujący na konkretnego dostawcę w tabeli Suppliers',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Components',
    @level2type=N'COLUMN',@level2name=N'SupplierID';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Nazwa danego komponentu',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Components',
    @level2type=N'COLUMN',@level2name=N'ComponentName';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Typ (kategoria) danego komponentu, np. części metalowe, śruby, itp.',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Components',
    @level2type=N'COLUMN',@level2name=N'ComponentType';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Jednostkowa cena zakupu danego komponentu',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Components',
    @level2type=N'COLUMN',@level2name=N'UnitPrice';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Liczba komponentów dostępnych w magazynie firmy, gotowych do wykorzystania do produkcji w czasie ~0',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Components',
    @level2type=N'COLUMN',@level2name=N'UnitsInStock';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Czas w dniach, w którym firma jest w stanie zakupić dodatkową ilość danego komponentu. -1 jezeli czas jest nieznany lub komponent wycofany z produkcji i nie da się go już zamówić',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Components',
    @level2type=N'COLUMN',@level2name=N'LeadTime';
GO

CREATE TABLE [Products] (
	[ID] INTEGER NOT NULL IDENTITY UNIQUE,
	PRIMARY KEY([ID])
);
GO


ALTER TABLE [CustomerDemographics]
ADD FOREIGN KEY([ID])
REFERENCES [Customers]([CustomerDemographicsID])
ON UPDATE NO ACTION ON DELETE NO ACTION;
GO
ALTER TABLE [Orders]
ADD FOREIGN KEY([CustomerID])
REFERENCES [Customers]([ID])
ON UPDATE NO ACTION ON DELETE NO ACTION;
GO
ALTER TABLE [Orders]
ADD FOREIGN KEY([EmployeeID])
REFERENCES [Employees]([ID])
ON UPDATE NO ACTION ON DELETE NO ACTION;
GO
ALTER TABLE [OrderDetails]
ADD FOREIGN KEY([OrderID])
REFERENCES [Orders]([ID])
ON UPDATE NO ACTION ON DELETE NO ACTION;
GO
ALTER TABLE [OrderDetails]
ADD FOREIGN KEY([ProductID])
REFERENCES [Products]([ID])
ON UPDATE NO ACTION ON DELETE NO ACTION;
GO
