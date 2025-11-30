USE dev;
BEGIN TRANSACTION;

BEGIN TRY

    -- =============================================
    -- 1. Independent Tables (Lookup & Base Data)
    -- =============================================

    -- Table: CustomerDemographics
    INSERT INTO [CustomerDemographics] ([AgeGroup], [HasChildren], [IncomeGroup], [IsCityResident])
    VALUES 
    (1, 0, 1, 1), -- Student / Young Adult
    (2, 1, 2, 1), -- Family in City
    (2, 1, 2, 0), -- Family in Countryside
    (3, 0, 3, 1), -- High Income, No Kids
    (3, 1, 3, 0); -- High Income, Countryside

    -- Table: Categories
    INSERT INTO [Categories] (CategoryName, Description, Picture)
    VALUES 
    ('Sypialnia', 'Łóżka, szafki nocne i materace', NULL),
    ('Salon', 'Sofy, fotele, stoliki kawowe', NULL),
    ('Kuchnia', 'Stoły, krzesła, zabudowa', NULL),
    ('Biuro', 'Biurka, krzesła obrotowe, regały', NULL),
    ('Ogród', 'Meble ogrodowe, leżaki', NULL);

    -- Table: Suppliers
    INSERT INTO [Suppliers] ([CompanyName], [ContactName], [ContactTitle], [StreetAddress], [City], [Region], [PostalCode], [Country], [PhoneNumber], [Fax])
    VALUES 
    ('Drewno-Pol S.A.', 'Jan Kowalski', 'Kierownik Sprzedaży', 'ul. Leśna 15', 'Tartakowo', 'Podkarpackie', '38-100', 'Polska', '+48 123 456 789', NULL),
    ('Stal-Met Sp. z o.o.', 'Anna Nowak', 'Dyrektor Handlowy', 'ul. Przemysłowa 5', 'Katowice', 'Śląskie', '40-001', 'Polska', '+48 987 654 321', '+48 987 654 320'),
    ('Fabryka Tkanin Łódź', 'Piotr Wiśniewski', 'Właściciel', 'ul. Piotrkowska 100', 'Łódź', 'Łódzkie', '90-001', 'Polska', '+48 42 678 90 12', NULL),
    ('Śruby i Wkręty', 'Krzysztof Zielony', 'Logistyk', 'ul. Metalowa 2', 'Poznań', 'Wielkopolskie', '60-100', 'Polska', '+48 61 888 77 66', NULL),
    ('Lakiery Premium', 'Maria Czarna', 'Konsultant', 'ul. Chemiczna 8', 'Wrocław', 'Dolnośląskie', '50-200', 'Polska', '+48 71 333 44 55', NULL);

    -- Table: EmployeePositions
    INSERT INTO [EmployeePositions] ([PositionName], [PositionDescription], [ProductivityFactor])
    VALUES 
    ('Kierownik Produkcji', 'Zarządzanie zespołem i planowanie', 1.00),
    ('Stolarz', 'Obróbka drewna i montaż', 1.50),
    ('Operator Maszyn', 'Obsługa maszyn CNC', 2.00),
    ('Magazynier', 'Przyjmowanie i wydawanie towaru', 1.00),
    ('Sprzedawca', 'Obsługa klienta w salonie', 1.00);

    -- Table: ProductRecipes
    -- (Mock data: Quantities of generic parts and labour hours)
    INSERT INTO [ProductRecipes] (Part1Quantity, Part2Quantity, Part3Quantity, LabourHours)
    VALUES 
    (10.5, 2.0, 0.5, 4.0), -- Recipe 1 (e.g. Table)
    (5.0, 1.0, 0.2, 2.0),  -- Recipe 2 (e.g. Chair)
    (20.0, 5.0, 2.0, 12.0),-- Recipe 3 (e.g. Wardrobe)
    (15.0, 0.0, 1.0, 6.5), -- Recipe 4 (e.g. Bed frame)
    (2.0, 0.5, 0.1, 0.5);  -- Recipe 5 (e.g. Small shelf)

    -- =============================================
    -- 2. First Level Dependencies
    -- =============================================

    -- Table: Customers
    INSERT INTO [Customers] ([CustomerDemographicsID], [ContactName], [ContactTitle], [Address], [City], [Region], [PostalCode], [Country], [PhoneNumber], [Fax])
    VALUES 
    (1, 'Alicja Malinowska', 'Właściciel', 'ul. Kwiatowa 5', 'Kraków', 'Małopolskie', '30-001', 'Polska', '500-100-100', NULL),
    (2, 'Bartosz Jakiś', 'Zaopatrzeniowiec', 'ul. Główna 20', 'Warszawa', 'Mazowieckie', '00-100', 'Polska', '600-200-200', '600-200-201'),
    (NULL, 'Firma Budowlana X', 'Prezes', 'ul. Inwestycyjna 1', 'Gdańsk', 'Pomorskie', '80-001', 'Polska', '58 555 44 33', NULL),
    (3, 'Cecylia Krawczyk', 'Klient Indywidualny', 'ul. Cicha 3', 'Zakopane', 'Małopolskie', '34-500', 'Polska', '700-300-300', NULL),
    (2, 'Restauracja Pod Dębem', 'Manager', 'Rynek 15', 'Wrocław', 'Dolnośląskie', '50-100', 'Polska', '71 222 33 44', NULL),
    (4, 'Hotel Lux', 'Dyrektor', 'Aleje Jerozolimskie 50', 'Warszawa', 'Mazowieckie', '00-200', 'Polska', '22 111 22 33', '22 111 22 34');

    -- Table: Employees 
    -- Note: We insert the Boss first (ReportsTo = NULL), then subordinates
    INSERT INTO [Employees] ([EmployeePositionID], [FirstName], [LastName], [BirthDate], [StreetAddress], [City], [Region], [PostalCode], [Country], [PhoneNumber], [ReportsTo], [PhotoBin])
    VALUES 
    (1, 'Adam', 'Szef', '1980-05-15', 'ul. Bogata 1', 'Kraków', 'Małopolskie', '30-100', 'Polska', '123-123-123', NULL, NULL);

    -- Get ID of the boss (Assuming Identity started at 1, but using variable is safer in scripts, though strict hardcoding for mock data is fine here)
    DECLARE @BossID INT = SCOPE_IDENTITY();

    INSERT INTO [Employees] ([EmployeePositionID], [FirstName], [LastName], [BirthDate], [StreetAddress], [City], [Region], [PostalCode], [Country], [PhoneNumber], [ReportsTo], [PhotoBin])
    VALUES 
    (2, 'Ewa', 'Pracowita', '1990-03-10', 'ul. Robotnicza 5', 'Kraków', 'Małopolskie', '31-200', 'Polska', '501-502-503', @BossID, NULL),
    (2, 'Jan', 'Młodszy', '1995-07-20', 'ul. Osiedlowa 10', 'Skawina', 'Małopolskie', '32-050', 'Polska', '601-602-603', @BossID, NULL),
    (3, 'Piotr', 'Techniczny', '1985-11-05', 'ul. Warsztatowa 8', 'Kraków', 'Małopolskie', '30-400', 'Polska', '701-702-703', @BossID, NULL),
    (5, 'Kasia', 'Sprzedażowa', '1992-01-30', 'ul. Handlowa 3', 'Kraków', 'Małopolskie', '31-500', 'Polska', '801-802-803', @BossID, NULL);

    -- Table: Components
    INSERT INTO [Components] ([SupplierID], [ComponentName], [ComponentType], [UnitPrice], [UnitsInStock], [LeadTime])
    VALUES 
    (1, 'Części drewniane', 'Drewno', 50.00, 500, 7),
    (1, 'Części drewniane', 'Drewno', 25.00, 1000, 3),
    (2, 'Części metalowe', 'Metal', 15.00, 200, 14),
    (4, 'Elementy łączące', 'Złącza', 0.10, 10000, 2),
    (3, 'Części z tworzywa', 'Plastiki', 30.00, 150, 10),
    (5, 'Części z tworzywa', 'Plastiki', 120.00, 20, 5);

    -- =============================================
    -- 3. Second Level Dependencies
    -- =============================================

    -- Table: Products
    INSERT INTO [Products] ([SupplierID], [CategoryID], [ProductName], [QuantityPerUnit], [UnitPrice], [ProductRecipesID])
    VALUES 
    (1, 3, 'Stół Dębowy Solid', 1, 1200.00, 1),
    (1, 3, 'Krzesło Dębowe', 4, 350.00, 2),
    (2, 2, 'Sofa Industrial', 1, 2500.00, 4),
    (1, 1, 'Szafa Przesuwna', 1, 1800.00, 3),
    (2, 4, 'Biurko Metal-Drewno', 1, 900.00, 1),
    (1, 1, 'Łóżko Kontynentalne', 1, 3200.00, 4),
    (1, 5, 'Ławka Ogrodowa', 1, 450.00, 5);

    -- Table: Orders
    INSERT INTO [Orders] ([CustomerID], [EmployeeID], [OrderDate], [RequiredDate], [Freight])
    VALUES 
    (1, 5, '2023-10-01', '2023-10-10', 50.00),
    (2, 5, '2023-10-05', '2023-10-20', 120.00),
    (3, 2, '2023-10-10', '2023-11-01', 200.00),
    (4, 5, '2023-10-12', '2023-10-15', 30.00),
    (1, 5, '2023-10-15', '2023-10-25', 60.00),
    (5, 2, '2023-10-20', '2023-11-20', 0.00); -- Free shipping

    -- =============================================
    -- 4. Third Level Dependencies
    -- =============================================

    -- Table: Warehouse
    -- Assuming Product IDs 1-7 generated above
    INSERT INTO [Warehouse] ([ProductID], [UnitsInStock], [LastStockUpdate], [StockLocation])
    VALUES 
    (1, 10, GETDATE(), 'Hala A, Rząd 1'),
    (2, 40, GETDATE(), 'Hala A, Rząd 2'),
    (3, 5, GETDATE(), 'Hala B, Rząd 1'),
    (4, 8, GETDATE(), 'Hala A, Rząd 3'),
    (5, 12, GETDATE(), 'Hala B, Rząd 2'),
    (6, 3, GETDATE(), 'Hala A, Rząd 4'),
    (7, 20, GETDATE(), 'Magazyn Zewnętrzny');

    -- Table: OrderDetails
    -- Linking Orders (1-6) with Products (1-7)
    INSERT INTO [OrderDetails] ([OrderID], [ProductID], [UnitPrice], [Quantity], [Discount])
    VALUES 
    (1, 1, 1200.00, 1, 0.00), -- Order 1: 1 Table
    (1, 2, 350.00, 4, 0.05),  -- Order 1: 4 Chairs (5% discount)
    (2, 3, 2500.00, 2, 0.00), -- Order 2: 2 Sofas
    (3, 4, 1800.00, 5, 0.10), -- Order 3: 5 Wardrobes (Bulk)
    (4, 7, 450.00, 2, 0.00),  -- Order 4: 2 Benches
    (5, 5, 900.00, 1, 0.00),  -- Order 5: 1 Desk
    (6, 6, 3200.00, 10, 0.15),-- Order 6: 10 Beds (Hotel order)
    (6, 1, 1200.00, 10, 0.15);-- Order 6: 10 Tables

    COMMIT TRANSACTION;
    PRINT 'Database populated successfully.';

END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error occurred. Transaction rolled back.';
    PRINT ERROR_MESSAGE();
END CATCH;
GO