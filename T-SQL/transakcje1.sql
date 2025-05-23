USE tempdb
GO

 DROP TABLE SzczegolyZamowienia
 DROP TABLE Zamowienia
 DROP TABLE Produkty
 
 

 -- Tworzenie tabeli tymczasowej dla produktów
CREATE TABLE Produkty (
    Produkt_ID INT IDENTITY PRIMARY KEY,
    Nazwa NVARCHAR(100) NOT NULL,
	Ilosc INT,
    Cena DECIMAL(10,2) NOT NULL
)
GO

-- Tworzenie tabeli tymczasowej dla zamówień
CREATE TABLE Zamowienia (
    Zamowienie_ID INT IDENTITY PRIMARY KEY,
    DataZamowienia DATETIME DEFAULT GETDATE(),
    Klient NVARCHAR(50) NOT NULL
)
GO

-- Tworzenie tabeli tymczasowej dla szczegółów zamówienia
CREATE TABLE SzczegolyZamowienia (
    Szczegoly_ID INT IDENTITY PRIMARY KEY,
    Zamowienie_ID INT REFERENCES Zamowienia(Zamowienie_ID) NOT NULL,
    Produkt_ID INT REFERENCES Produkty(Produkt_ID) NOT NULL,
    Ilosc INT NOT NULL CHECK (Ilosc > 0),
    CenaJednostkowa DECIMAL(10,2) NOT NULL
)
GO

-- Uzupełnienie tabeli 'Produkty' przykładowymi wartościami
INSERT INTO Produkty (Nazwa, Ilosc, Cena)  
VALUES  
    ('Laptop Dell XPS 15', 10, 6999.99),  
    ('Smartfon Samsung Galaxy S23', 20, 3999.50),  
    ('Monitor LG 27" 4K', 15, 1799.00),  
    ('Klawiatura Mechaniczna Logitech', 30, 499.99),  
    ('Myszka Razer DeathAdder', 25, 299.90),  
    ('Dysk SSD Samsung 1TB', 40, 599.99),  
    ('Słuchawki Sony WH-1000XM4', 18, 1299.00),  
    ('Kamera Logitech C920 HD', 22, 449.99),  
    ('Drukarka HP LaserJet Pro', 12, 899.50),  
    ('Tablet Apple iPad Air', 8, 3499.00)
GO


SELECT * FROM Produkty
SELECT * FROM Zamowienia
SELECT * FROM SzczegolyZamowienia
GO

-- Deklaracje zmiennych dla zamówienia
DECLARE @Klient NVARCHAR(50) = 'XYZ Sp.z o.o.'
DECLARE @Produkt_ID INT = 3
DECLARE @Ilosc INT = 7
DECLARE @CenaJednostkowa DECIMAL
SELECT @CenaJednostkowa = Cena FROM Produkty WHERE Produkt_ID=@Produkt_ID


-- Transakcja 
BEGIN TRAN

	INSERT INTO Zamowienia (DataZamowienia, Klient) VALUES (GETDATE(), @Klient)
	DECLARE @Zamowienie_ID INT = SCOPE_IDENTITY()
	INSERT INTO SzczegolyZamowienia(Zamowienie_ID,Produkt_ID,Ilosc,CenaJednostkowa) VALUES (@Zamowienie_ID,@Produkt_ID,@Ilosc,@CenaJednostkowa)
	UPDATE Produkty SET Ilosc= Ilosc-@Ilosc WHERE Produkt_ID = @Produkt_ID

IF (SELECT Ilosc FROM Produkty WHERE Produkt_ID = @Produkt_ID) < 0
	BEGIN
		PRINT 'Brak wystarczajacej ilosci produktu w magazynie'
		ROLLBACK
	END
ELSE 
	BEGIN
		PRINT 'Zamowienie zlozone'
		COMMIT
	END
		

SELECT * FROM Produkty
SELECT * FROM Zamowienia
SELECT * FROM SzczegolyZamowienia
GO