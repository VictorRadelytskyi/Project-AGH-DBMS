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

CREATE TABLE [Employees] (
	[ID] INTEGER NOT NULL IDENTITY UNIQUE,
	PRIMARY KEY([ID])
);
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
