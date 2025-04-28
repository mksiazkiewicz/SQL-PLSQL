/*1. Oto dwie tabele, które s³u¿¹ do przechowywania ofert sklepu Biedl i Lidronka. Utwórz je w 
swojej bazie danych. 
CREATE TABLE dbo.Biedl( 
  Id INT IDENTITY PRIMARY KEY, 
  Name NVARCHAR(100), 
  Price DECIMAL(10,2)); 
GO 
CREATE TABLE dbo.Lidronka( 
  Id INT IDENTITY PRIMARY KEY, 
  Name NVARCHAR(100), 
  Price DECIMAL(10,2)); 
GO 
 
INSERT INTO dbo.Biedl(Name,Price) VALUES('Apples',3),('Oranges', 3),('Lemons', 3); 
INSERT INTO dbo.Lidronka(Name,Price) VALUES('Apples',3),('Oranges', 3),('Lemons', 3); 
GO 
2. Analitycy czêsto u¿ywali zapytania w poni¿szej postaci. Przetestuj dzia³anie tego zapytania i 
stwórz widok, pozwalaj¹cy analitykom na korzystanie z po³¹czonych danych bez koniecznoœci 
pisania zapytania 
SELECT 'BIEDL' AS Shop, Name, Price FROM Biedl 
UNION ALL 
SELECT 'LIDRONKA' AS Shop, Name, Price FROM Lidronka; 
GO 
3. Stwórz trigger INSTEAD OF INSERT, który pozwoli wprowadzaæ rekordy do widoku, tak ¿eby 
rekordy trafia³y do w³aœciwej tabeli Ÿród³owej. 
4. Przetestuj dzia³anie triggera*/

--1
CREATE TABLE dbo.Biedl( 
  Id INT IDENTITY PRIMARY KEY, 
  Name NVARCHAR(100), 
  Price DECIMAL(10,2)); 
GO 
CREATE TABLE dbo.Lidronka( 
  Id INT IDENTITY PRIMARY KEY, 
  Name NVARCHAR(100), 
  Price DECIMAL(10,2)); 
GO 
 
INSERT INTO dbo.Biedl(Name,Price) VALUES('Apples',3),('Oranges', 3),('Lemons', 3); 
INSERT INTO dbo.Lidronka(Name,Price) VALUES('Apples',3),('Oranges', 3),('Lemons', 3); 
GO 

--2
SELECT 'BIEDL' AS Shop, Name, Price FROM Biedl 
UNION ALL 
SELECT 'LIDRONKA' AS Shop, Name, Price FROM Lidronka; 
GO 

CREATE VIEW vShops AS
SELECT 'BIEDL' AS Shop, Name, Price FROM Biedl 
UNION ALL 
SELECT 'LIDRONKA' AS Shop, Name, Price FROM Lidronka; 
GO 

SELECT * FROM vShops;
GO

--3
CREATE OR ALTER TRIGGER tr_vShops_insert ON vShops INSTEAD OF INSERT
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO dbo.Biedl (Name, Price)
	SELECT i.Name, i.Price
	FROM INSERTED i WHERE Shop = 'BIEDL';

	INSERT INTO dbo.Lidronka (Name, Price)
	SELECT i.Name, i.Price
	FROM INSERTED i WHERE Shop = 'LIDRONKA';
END;
GO

INSERT INTO vShops
VALUES ('BIEDL', 'Carrots', 1);
GO

INSERT INTO vShops
VALUES ('LIDRONKA', 'Carrots', 2)
GO

SELECT * FROM vShops;
SELECT * FROM dbo.Biedl;
SELECT * FROM dbo.Lidronka;