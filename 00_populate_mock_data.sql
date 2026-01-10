INSERT INTO [CustomerDemographics] ([AgeGroup], [HasChildren], [IncomeGroup], [IsCityResident])
VALUES 
(1, 0, 1, 1), -- Studenci/Młodzi, miasto, niskie dochody
(2, 1, 2, 1), -- Młodzi rodzice, średnie dochody
(3, 1, 3, 0), -- Wiek średni, wysokie dochody, wieś/przedmieścia
(2, 0, 2, 1), -- Młodzi pracujący, bez dzieci
(4, 1, 2, 0), -- Starsi, średnie dochody
(5, 0, 1, 1); -- Seniorzy, miasto


INSERT INTO [Customers] 
([CustomerDemographicsID], [ContactName], [ContactTitle], [Address], [City], [Region], [PostalCode], [Country], [PhoneNumber], [Fax], [NIP])
VALUES
(2, 'Jan Kowalski', 'Właściciel', 'ul. Długa 15/4', 'Kraków', 'Małopolskie', '31-146', 'Polska', '+48 123 456 789', NULL, '6770001122'),
(3, 'Anna Nowak', 'Dyrektor Zaopatrzenia', 'Al. Jerozolimskie 100', 'Warszawa', 'Mazowieckie', '00-807', 'Polska', '+48 22 333 44 55', '+48 22 333 44 56', '5250001234'),
(1, 'Piotr Wiśniewski', 'Klient Indywidualny', 'ul. Piotrkowska 55', 'Łódź', 'Łódzkie', '90-001', 'Polska', '+48 500 600 700', NULL, NULL),
(4, 'Meble-Lux Sp. z o.o.', 'Marek Zając', 'ul. Przemysłowa 8', 'Poznań', 'Wielkopolskie', '60-101', 'Polska', '+48 61 888 99 00', NULL, '7778889900'),
(2, 'Katarzyna Wójcik', 'Manager', 'ul. Słowackiego 3', 'Gdańsk', 'Pomorskie', '80-001', 'Polska', '+48 58 123 45 67', NULL, '9570002233'),
(3, 'Hotel "Pod Różą"', 'Tomasz Mazur', 'Rynek Główny 14', 'Kraków', 'Małopolskie', '31-001', 'Polska', '+48 12 444 55 66', '+48 12 444 55 67', '6760005566'),
(1, 'Ewa Krawczyk', 'Projektant Wnętrz', 'ul. Szewska 2', 'Wrocław', 'Dolnośląskie', '50-053', 'Polska', '+48 71 345 67 89', NULL, '8980001122'),
(5, 'Dom Seniora "Złota Jesień"', 'Jadwiga Sienkiewicz', 'ul. Leśna 10', 'Zakopane', 'Małopolskie', '34-500', 'Polska', '+48 18 201 20 20', NULL, '7360009988'),
(2, 'Biuro Projektowe "Kreska"', 'Adam Małecki', 'ul. Marszałkowska 50', 'Warszawa', 'Mazowieckie', '00-500', 'Polska', '+48 22 628 00 00', NULL, '5260007788'),
(4, 'Restauracja "Smak"', 'Monika Lis', 'ul. Floriańska 20', 'Kraków', 'Małopolskie', '31-021', 'Polska', '+48 12 422 11 11', NULL, '6761112233');


INSERT INTO [EmployeePositions] ([PositionName], [PositionDescription], [ProductivityFactor])
VALUES
('Kierownik Produkcji', 'Nadzoruje proces produkcji mebli', 1.00),
('Stolarz', 'Obróbka drewna i montaż elementów drewnianych', 1.20),
('Tapicer', 'Obijanie mebli tkaninami', 1.10),
('Lakiernik', 'Lakierowanie i zabezpieczanie powierzchni', 1.00),
('Specjalista ds. Sprzedaży', 'Kontakt z klientem i przyjmowanie zamówień', 1.00),
('Magazynier', 'Przyjmowanie dostaw i wydawanie towaru', 1.00),
('Specjalista ds. HR', 'Zarządzanie pracownikami w firmie', 1.00);

-- Kierownicy (ReportsTo = NULL)
INSERT INTO [Employees] 
([EmployeePositionID], [FirstName], [LastName], [BirthDate], [StreetAddress], [City], [Region], [PostalCode], [Country], [PhoneNumber], [ReportsTo])
VALUES
(1, 'Andrzej', 'Nowicki', '1975-03-15', 'ul. Lipowa 4', 'Wieliczka', 'Małopolskie', '32-020', 'Polska', '+48 601 100 200', NULL), -- ID 1
(5, 'Beata', 'Kozłowska', '1980-07-20', 'ul. Królewska 12', 'Kraków', 'Małopolskie', '30-045', 'Polska', '+48 602 300 400', NULL); -- ID 2

-- Pracownicy (ReportsTo wskazuje na ID 1 lub 2)
INSERT INTO [Employees] 
([EmployeePositionID], [FirstName], [LastName], [BirthDate], [StreetAddress], [City], [Region], [PostalCode], [Country], [PhoneNumber], [ReportsTo])
VALUES
(2, 'Krzysztof', 'Zieliński', '1985-05-10', 'os. Dywizjonu 303', 'Kraków', 'Małopolskie', '31-872', 'Polska', '+48 501 234 567', 1), -- Stolarz, szef ID 1
(2, 'Marek', 'Jankowski', '1990-11-05', 'ul. Mogilska 20', 'Kraków', 'Małopolskie', '31-516', 'Polska', '+48 502 345 678', 1), -- Stolarz, szef ID 1
(3, 'Iwona', 'Maj', '1988-02-14', 'ul. Bronowicka 55', 'Kraków', 'Małopolskie', '30-084', 'Polska', '+48 503 456 789', 1), -- Tapicer, szef ID 1
(3, 'Paweł', 'Kaczmarek', '1995-09-30', 'ul. Wielicka 100', 'Kraków', 'Małopolskie', '30-552', 'Polska', '+48 504 567 890', 1), -- Tapicer, szef ID 1
(4, 'Tomasz', 'Wróbel', '1982-12-12', 'ul. Zakopiańska 70', 'Kraków', 'Małopolskie', '30-418', 'Polska', '+48 505 678 901', 1), -- Lakiernik, szef ID 1
(5, 'Magdalena', 'Pawlak', '1993-04-25', 'ul. Opolska 15', 'Kraków', 'Małopolskie', '31-323', 'Polska', '+48 506 789 012', 2), -- Sprzedawca, szef ID 2
(6, 'Grzegorz', 'Sikora', '1978-08-08', 'ul. Półłanki 12', 'Kraków', 'Małopolskie', '30-740', 'Polska', '+48 507 890 123', 1), -- Magazynier, szef ID 1
(7, 'Alicja', 'Duda', '1989-01-20', 'ul. Lea 202', 'Kraków', 'Małopolskie', '30-133', 'Polska', '+48 508 901 234', 1), -- Projektant, szef ID 1
(2, 'Rafał', 'Wilk', '1999-06-01', 'ul. Dobrego Pasterza 50', 'Kraków', 'Małopolskie', '31-416', 'Polska', '+48 509 012 345', 1); -- Stolarz, szef ID 1

INSERT INTO [Suppliers] ([CompanyName], [ContactName], [ContactTitle], [StreetAddress], [City], [Region], [PostalCode], [Country], [PhoneNumber], [Fax])
VALUES
('Tartak "Dąb"', 'Janusz Drzewiecki', 'Właściciel', 'ul. Leśna 1', 'Nowy Sącz', 'Małopolskie', '33-300', 'Polska', '+48 18 444 33 22', NULL),
('Hurtownia Tapicerska "Tkanina"', 'Maria Krawiec', 'Handlowiec', 'ul. Fabryczna 10', 'Łódź', 'Łódzkie', '90-300', 'Polska', '+48 42 678 90 00', NULL),
('Metal-Zbyt', 'Piotr Stalowy', 'Kierownik Sprzedaży', 'ul. Hutnicza 5', 'Katowice', 'Śląskie', '40-001', 'Polska', '+48 32 200 11 22', '+48 32 200 11 23'),
('Chemia Meblowa Pro', 'Adam Lakier', 'Dyrektor', 'ul. Chemiczna 3', 'Bydgoszcz', 'Kujawsko-Pomorskie', '85-001', 'Polska', '+48 52 300 40 50', NULL),
('Akcesoria Meblowe "Gałka"', 'Ewa Uchwyt', 'Sprzedawca', 'ul. Handlowa 22', 'Warszawa', 'Mazowieckie', '03-100', 'Polska', '+48 22 888 77 66', NULL),
('Pianki i Gąbki', 'Roman Miękki', 'Właściciel', 'ul. Przemysłowa 8', 'Radom', 'Mazowieckie', '26-600', 'Polska', '+48 48 360 00 00', NULL),
('Szkło-Lux', 'Barbara Szyba', 'Manager', 'ul. Szklana 12', 'Krosno', 'Podkarpackie', '38-400', 'Polska', '+48 13 432 10 00', NULL),
('Śruby i Wkręty S.A.', 'Marek Gwint', 'Handlowiec', 'ul. Śrubowa 1', 'Wrocław', 'Dolnośląskie', '53-611', 'Polska', '+48 71 789 01 23', NULL),
('Okleiny Naturalne', 'Zofia Fornir', 'Specjalista', 'ul. Stolarska 4', 'Kalwaria Zebrzydowska', 'Małopolskie', '34-130', 'Polska', '+48 33 876 54 32', NULL),
('Kleje Przemysłowe', 'Kamil Spoiwo', 'Doradca Techniczny', 'ul. Techniczna 7', 'Poznań', 'Wielkopolskie', '60-101', 'Polska', '+48 61 800 20 30', NULL);

INSERT INTO [Components] ([SupplierID], [ComponentName], [ComponentType], [UnitPrice])
VALUES
(1, 'Deska Dębowa 200x20x2', 'Drewno', 45.00),
(1, 'Deska Sosnowa 200x20x2', 'Drewno', 25.00),
(1, 'Noga toczona bukowa', 'Drewno', 15.00),
(2, 'Welur tapicerski Granat', 'Tkanina', 30.00),
(2, 'Ekoskóra Beż', 'Tkanina', 22.00),
(6, 'Pianka T35 10cm', 'Wypełnienie', 18.00),
(3, 'Prowadnica szuflady 40cm', 'Inne', 12.00),
(5, 'Uchwyt meblowy Chrom', 'Inne', 8.50),
(8, 'Wkręty do drewna 4x40 (paczka 100)', 'Elementy złączne', 15.00),
(8, 'Wkręty do drewna 2x40 (paczka 100)', 'Elementy złączne', 10.00),
(8, 'Wkręty do drewna 1x25 (paczka 100)', 'Elementy złączne', 7.00),
(4, 'Lakier Poliuretanowy Mat', 'Inne', 120.00),
(10, 'Klej do drewna Wikol 5kg', 'Inne', 40.00),
(7, 'Szyba hartowana 100x50', 'Inne', 150.00),
(9, 'Fornir Dębowy arkusz', 'Inne', 55.00),
(3, 'Stelaż krzesła metalowy', 'Inne', 80.00);

INSERT INTO [Categories] ([CategoryName], [Description], [Picture])
VALUES
('Stoły', 'Stoły jadalniane, kawowe i konferencyjne', NULL),
('Krzesła', 'Krzesła drewniane, tapicerowane i metalowe', NULL),
('Sofy', 'Sofy wypoczynkowe, kanapy i narożniki', NULL),
('Szafy', 'Szafy wolnostojące, przesuwne i garderoby', NULL),
('Biurka', 'Biurka gabinetowe, komputerowe i szkolne', NULL),
('Komody', 'Komody z szufladami i szafkami', NULL),
('Łóżka', 'Łóżka sypialniane drewniane i tapicerowane', NULL);

INSERT INTO [ProductRecipes] ([RecipeName], [LabourHours])
VALUES
('Produkcja Stół Dębowy Max', 8.00),
('Produkcja Krzesło Tapicerowane Klasyk', 2.50),
('Produkcja Sofa 3-osobowa Relax', 12.00),
('Produkcja Szafa Przesuwna 150', 5.00),
('Produkcja Biurko Proste Sosna', 3.00),
('Produkcja Komoda 4 szuflady', 4.50),
('Produkcja Łóżko Kontynentalne 160', 10.00),
('Produkcja Stolik Kawowy Szkło', 2.00),
('Produkcja Krzesło Loft Metal', 1.50),
('Produkcja Regał Biblioteczny', 6.00),
('Produkcja Fotel Uszak', 9.00);


INSERT INTO [RecipeIngredients] ([ProductRecipeID], [ComponentID], [QuantityRequired])
VALUES
-- Stół Dębowy Max (ID 1)
(1, 1, 10.00), -- Deska Dębowa
(1, 4, 1.00),  -- Lakier
(1, 12, 1.00), -- Klej

-- Krzesło Tapicerowane (ID 2)
(2, 3, 4.00),  -- Nogi bukowe
(2, 6, 1.00),  -- Pianka (metry kw)
(2, 4, 1.00),  -- Welur
(2, 8, 1.00),  -- Wkręty

-- Sofa Relax (ID 3)
(3, 2, 8.00),  -- Deska sosnowa (konstrukcja)
(3, 6, 5.00),  -- Pianka
(3, 5, 8.00),  -- Ekoskóra

-- Szafa Przesuwna (ID 4)
(4, 14, 10.00), -- Fornir
(4, 7, 4.00),   -- Prowadnice
(4, 8, 2.00),   -- Uchwyty

-- Biurko Sosna (ID 5)
(5, 2, 6.00),  -- Deska sosnowa
(5, 7, 2.00),  -- Prowadnice
(5, 8, 2.00),  -- Uchwyty

-- Komoda 4 szuflady (ID 6)
(6, 2, 4.00),  -- Deska sosnowa
(6, 7, 4.00),  -- Prowadnice
(6, 8, 2.00),  -- Uchwyty


-- Łóżko Kontynentalne (ID 7)
(7, 3, 4.00),  -- Nogi bukowe
(7, 2, 8.00),  -- Deska sosnowa
(7, 4, 1.00),  -- Welur
(7, 8, 1.00),  -- Wkręty

-- Stolik Kawowy Szkło (ID 8)
(8, 13, 1.00), -- Szyba
(8, 3, 4.00),  -- Nogi

-- Krzesło Loft (ID 9)
(9, 15, 1.00), -- Stelaż metalowy
(9, 5, 1.00),  -- Ekoskóra (siedzisko)

-- Regał Biblioteczny (ID 10)
(10, 15, 3.00), -- Stelaż metalowy
(10, 8, 2.00),  -- Wkręty

-- Fotel Uszak (ID 11)
(11, 2, 8.00),  -- Deska sosnowa (konstrukcja)
(11, 6, 5.00),  -- Pianka
(11, 5, 8.00);  -- Ekoskóra

INSERT INTO [Products] ([SupplierID], [CategoryID], [ProductName], [QuantityPerUnit], [UnitPrice], [ProductRecipesID], [VATMultipler])
VALUES
(1, 1, 'Stół Dębowy Solid', 1, 1500.00, 1, 1.23),
(1, 2, 'Krzesło Tapicerowane Królewskie', 1, 350.00, 2, 1.23),
(6, 3, 'Sofa Wypoczynkowa "Chmurka"', 1, 2200.00, 3, 1.23),
(9, 4, 'Szafa Przesuwna Dąb Naturalny', 1, 1800.00, 4, 1.23),
(1, 5, 'Biurko Ucznia Sosnowe', 1, 450.00, 5, 1.23),
(1, 6, 'Komoda Dębowa 4S', 1, 900.00, 6, 1.23),
(6, 7, 'Łóżko Hotelowe King Size', 1, 2500.00, 7, 1.23),
(7, 1, 'Stolik Kawowy Nowoczesny', 1, 300.00, 8, 1.23),
(3, 2, 'Krzesło Industrialne Black', 1, 200.00, 9, 1.23),
(1, 4, 'Regał na Książki Classic', 1, 750.00, 10, 1.23),
(6, 3, 'Fotel Uszak Szary', 1, 800.00, 11, 1.23);
GO