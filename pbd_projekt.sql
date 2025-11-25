CREATE TABLE [Customers] (
	[ID] INT NOT NULL IDENTITY UNIQUE,
	[CustomerDemographicsID] INT,
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
	[ID] INT NOT NULL IDENTITY UNIQUE,
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
	[ID] INT NOT NULL IDENTITY UNIQUE,
	[CustomerID] INT NOT NULL,
	[EmployeeID] INT NOT NULL,
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
	[OrderID] INT NOT NULL IDENTITY UNIQUE,
	[ProductID] INT NOT NULL,
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
    [ProductivityFactor] DECIMAL(4,2) NOT NULL CHECK([ProductivityFactor] BETWEEN 0 AND 10)
);
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

CREATE TABLE [Products] (
	[ID] INT IDENTITY,
    [SupplierID] INT NOT NULL, 
    [CategoryID] INT NOT NULL, 
    ProductName VARCHAR(250) NOT NULL, 
    QuantityPerUnit INT NOT NULL, 
    UnitPrice DECIMAL(10, 2) NOT NULL CHECK([UnitPrice] >= 0.00), 
    ProductRecipesID INT NOT NULL,
    FOREIGN KEY ([SupplierID]) REFERENCES [Suppliers]([ID]),
	PRIMARY KEY([ID])
);
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Ilość jednostek towaru w pewnym produkcie, n.p. komplet 4 krzeseł - QuantityPerUnit = 1',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Products',
    @level2type=N'COLUMN',@level2name=N'QuantityPerUnit';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Cena towaru',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Products',
    @level2type=N'COLUMN',@level2name=N'UnitPrice';
GO

CREATE TABLE [Categories] (
	[ID] INT IDENTITY,
    CategoryName VARCHAR(250) NOT NULL, 
    Description VARCHAR(8000), 
    Picture VARBINARY(MAX),
	PRIMARY KEY([ID])
);
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Tabela opisująca kategorie produktów, n.p. Sofy, wraz z opisem kategorii i obrazkiem',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Categories'
GO


CREATE TABLE [Warehouse] (
	[ID] INT IDENTITY,
    ProductID INT NOT NULL,
    UnitsInStock INT NOT NULL,
    LastStockUpdate DATETIME DEFAULT GETDATE(),
    StockLocation VARCHAR(150) NOT NULL,
    FOREIGN KEY([ProductID]) REFERENCES [Products](ID),
	PRIMARY KEY([ID])
);
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Tabela reprezentująca każdy dostępny produkt w sklepie - w jakim miejscu się znajduje (StockLocation) oraz w jakiej ilości (UnitsInStock)',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Warehouse'
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Miejsce w którym znajduje się product o id ProductID',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Warehouse',
    @level2type=N'COLUMN',@level2name=N'StockLocation'
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Ilość dostępnych produktów o ID ProductID w składzie o lokalizacji StockLocation',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'Warehouse',
    @level2type=N'COLUMN',@level2name=N'UnitsInStock'
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Data ostatniej aktualizacji stanu magazynowego dla danego produktu',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'SCHEMA',@level1name=N'Warehouse',
    @level2type=N'COLUMN',@level2name=N'LastStockUpdate'
GO

/* Todo: opis stockdate */

CREATE TABLE [ProductRecipes] (
	[ID] INT IDENTITY,
    Part1Quantity DECIMAL(10, 2) NOT NULL,
    Part2Quantity DECIMAL(10, 2) NOT NULL,
    Part3Quantity DECIMAL(10, 2) NOT NULL,
    LabourHours DECIMAL(10, 2) NOT NULL,
	PRIMARY KEY([ID])
);
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Tabela reprezentująca ilość materiału potrzebnego do produkcji produktu o ID ID (takim samym jak PK w ProductRecipes) oraz czasu pracy który potrzeba spędzić przez pracowników, żeby ten produkt wyprodukować. Np. krzesło, 2kg drewna, 0.5kg żelaza, 6 godzin',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'ProductRecipes'
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Czas roboczy potrzebny dla produkcji produktu o ID ID',
    @level0type=N'SCHEMA',@level0name=N'dbo',
    @level1type=N'TABLE',@level1name=N'ProductRecipes',
    @level2type=N'COLUMN',@level2name=N'LabourHours'
GO

/* Todo: wybrać konkretne materiały wraz z jednostką w której je mierzymy, n.p. gramy */

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
ALTER TABLE [Products]
ADD FOREIGN KEY ([CategoryID]) REFERENCES [Categories]([ID]),
FOREIGN KEY ([ProductRecipesID]) REFERENCES  [ProductRecipes]([ID])
ON UPDATE NO ACTION ON DELETE NO ACTION;
GO
