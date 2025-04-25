/*
1. Oto kod tworz¹cy potrzebne nam tabele. Uruchom go u siebie: 
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
2. W najbli¿szych laboratoriach bêdziemy pracowaæ nad tak¹ sytuacj¹: 
a. W tabeli produktów (dbo.Products) przechowywana bêdzie informacja o ca³kowitej 
liczbie produktów w magazynie. 
b. Te produkty bêd¹ kupowane i sprzedawane, a informacje o tym zapiszemy w tabeli Transactions 
	i. Ilekroæ zostanie dodany rekord zakupu dla danego produktu (typ rekordu B jak 
	BUY), trzeba bêdzie zaktualizowaæ rekord produktu dodaj¹c do aktualnej liczby 
	produktów (TotalAmount) liczbê kupionych produktów (Amount) 
	ii. Ilekroæ zostanie dodany rekord sprzeda¿y dla danego produktu (typ rekordu S 
	jak SELL), trzeba bêdzie zaktualizowaæ rekord produktu odejmuj¹c od aktualnej 
	liczby produktów (TotalAmount) liczbê sprzedanych produktów (Amount). 
c. Zak³adamy, ¿e w pojedynczej operacji zapisu dany produkt mo¿e siê pojawiæ tylko jeden 
raz. Gdyby tak nie by³o, to trigger musia³by sumowaæ wartoœci dla wstawianych 
rekordów, co oczywiœcie mo¿na oprogramowaæ, ale by³oby trochê trudne2. Mo¿esz 
sprawdziæ, czy ten warunek jest spe³niony dodaj¹c jako jedn¹ z pierwszych instrukcji 
triggera nastêpuj¹cy kod: 
IF EXISTS (SELECT COUNT(*) FROM inserted GROUP BY ProductId HAVING COUNT(*) > 1) 
THROW 50001, 'ONE TRANSACTION CAN UPDATE A PRODUCT ONLY ONCE',1;
3. Napisz trigger, który w przypadku dodania rekordu typu B do tabeli Products zwiêkszy stan 
produktów, a w przypadku dodania rekordu typu S, zmniejszy stan produktów. 
4. Przetestuj dzia³anie triggera tworz¹c np. nastêpuj¹ce transakcje: 

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