/*
1. Oto kod tworz�cy potrzebne nam tabele. Uruchom go u siebie: 
CREATE TABLE dbo.Products( 
Id INT IDENTITY PRIMARY KEY, 
Name NVARCHAR(100), 
TotalAmount INT DEFAULT 0); 
GO 
CREATE TABLE dbo.Transactions( 
Id INT IDENTITY PRIMARY KEY, 
ProductId INT NOT NULL REFERENCES dbo.Products(Id), 
RecordType CHAR(1),  -- 'S' - product Sold / 'B' - product Bought 
Amount INT NOT NULL DEFAULT 0, 
CONSTRAINT ProductId_Id UNIQUE(ProductId, Id)); 
GO 
INSERT INTO dbo.Products(Name) VALUES('Apples'),('Oranges'),('Lemons'); 
GO 
2. W najbli�szych laboratoriach b�dziemy pracowa� nad tak� sytuacj�: 
a. W tabeli produkt�w (dbo.Products) przechowywana b�dzie informacja o ca�kowitej 
liczbie produkt�w w magazynie. 
b. Te produkty b�d� kupowane i sprzedawane, a informacje o tym zapiszemy w tabeli Transactions 
	i. Ilekro� zostanie dodany rekord zakupu dla danego produktu (typ rekordu B jak 
	BUY), trzeba b�dzie zaktualizowa� rekord produktu dodaj�c do aktualnej liczby 
	produkt�w (TotalAmount) liczb� kupionych produkt�w (Amount) 
	ii. Ilekro� zostanie dodany rekord sprzeda�y dla danego produktu (typ rekordu S 
	jak SELL), trzeba b�dzie zaktualizowa� rekord produktu odejmuj�c od aktualnej 
	liczby produkt�w (TotalAmount) liczb� sprzedanych produkt�w (Amount). 
c. Zak�adamy, �e w pojedynczej operacji zapisu dany produkt mo�e si� pojawi� tylko jeden 
raz. Gdyby tak nie by�o, to trigger musia�by sumowa� warto�ci dla wstawianych 
rekord�w, co oczywi�cie mo�na oprogramowa�, ale by�oby troch� trudne2. Mo�esz 
sprawdzi�, czy ten warunek jest spe�niony dodaj�c jako jedn� z pierwszych instrukcji 
triggera nast�puj�cy kod: 
IF EXISTS (SELECT COUNT(*) FROM inserted GROUP BY ProductId HAVING COUNT(*) > 1) 
THROW 50001, 'ONE TRANSACTION CAN UPDATE A PRODUCT ONLY ONCE',1;
3. Napisz trigger, kt�ry w przypadku dodania rekordu typu B do tabeli Products zwi�kszy stan 
produkt�w, a w przypadku dodania rekordu typu S, zmniejszy stan produkt�w. 
4. Przetestuj dzia�anie triggera tworz�c np. nast�puj�ce transakcje: 

INSERT INTO dbo.Transactions(ProductId, RecordType, Amount) VALUES (1, 'B',  
100),(2, 'B', 200),(3, 'B', 300); 
SELECT * FROM dbo.Products 
 
INSERT INTO dbo.Transactions(ProductId, RecordType, Amount) VALUES (1, 'S', 10), 
(2, 'S', 20), (3, 'B', 300); 
SELECT * FROM dbo.Products 
*/

--1
CREATE TABLE dbo.Products( 
Id INT IDENTITY PRIMARY KEY, 
Name NVARCHAR(100), 
TotalAmount INT DEFAULT 0); 
GO 
CREATE TABLE dbo.Transactions( 
Id INT IDENTITY PRIMARY KEY, 
ProductId INT NOT NULL REFERENCES dbo.Products(Id), 
RecordType CHAR(1),  -- 'S' - product Sold / 'B' - product Bought 
Amount INT NOT NULL DEFAULT 0, 
CONSTRAINT ProductId_Id UNIQUE(ProductId, Id)); 
GO 
INSERT INTO dbo.Products(Name) VALUES('Apples'),('Oranges'),('Lemons'); 
GO 

--3
CREATE OR ALTER TRIGGER tr_insert_transactions ON dbo.Transactions FOR INSERT
AS
BEGIN
	SET NOCOUNT ON;
	--2
	IF EXISTS (SELECT COUNT(*) FROM inserted GROUP BY ProductId HAVING COUNT(*) > 1) 
	THROW 50001, 'ONE TRANSACTION CAN UPDATE A PRODUCT ONLY ONCE',1;

	-- dla transakcji typu 'B'
	UPDATE dbo.Products
	SET TotalAmount = TotalAmount + i.Amount
	FROM dbo.Products p 
	JOIN inserted i ON p.Id = i.ProductId
	WHERE i.RecordType = 'B';

	-- dla transakcji typu 'S'
	UPDATE dbo.Products
	SET TotalAmount = TotalAmount - i.Amount
	FROM dbo.Products p 
	JOIN inserted i ON p.Id=i.ProductId
	WHERE i.RecordType = 'S';
END;
GO

--4
INSERT INTO dbo.Transactions(ProductId, RecordType, Amount) VALUES (1, 'B',  
100),(2, 'B', 200),(3, 'B', 300); 
SELECT * FROM dbo.Products 
 
INSERT INTO dbo.Transactions(ProductId, RecordType, Amount) VALUES (1, 'S', 10), 
(2, 'S', 20), (3, 'B', 300); 
SELECT * FROM dbo.Products 