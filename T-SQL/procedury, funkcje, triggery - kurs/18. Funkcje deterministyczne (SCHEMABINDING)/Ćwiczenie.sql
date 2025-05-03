/*1. Kolumna wyliczana zaprezentowana na lekcji, wymaga od SQL Server wykonywania obliczenia 
warto�ci tej kolumny zawsze, kiedy u�ytkownik pobiera dane z tej tabeli. Powoduje to obci��enie 
CPU podczas wykonywania zapyta�, dlatego istnieje mo�liwo�� zapisania raz wyznaczonych 
warto�ci na dysk. Takie obliczenie b�dzie wykonane tylko po wykonaniu polecenia INSERT i 
UPDATE, a polecenie SELECT b�dzie jedynie odczytywa� t� warto��. W poleceniu ALTER TABLE 
ADD COLUMN wystarczy doda� s�owo PERSISTED, a warto�� b�dzie ju� zapisana na dysku. 
2. Utw�rz funkcj�, kt�ra dla danej ilo�ci, ceny i rabatu wyznaczy warto�� zam�wienia. Przetestuj 
wyliczanie warto�ci na tabeli Sales.SalesOrderDetail. Skorzystaj z kodu poni�ej: 
CREATE OR ALTER FUNCTION dbo.GetOrderValue(@OrderQty SMALLINT, @UnitPrice MONEY, 
@UnitPriceDiscount MONEY) 
RETURNS MONEY 
AS 
BEGIN 
 RETURN @OrderQty * (@UnitPrice - @UnitPriceDiscount); 
END 
GO 
 
SELECT dbo.GetOrderValue(OrderQty, UnitPrice, UnitPriceDiscount), * FROM 
Sales.SalesOrderDetail;  
 
3. Do tabeli Sales.SalesOrderDetail dodaj kolumn� OrderValue, kt�ra b�dzie wype�niona warto�ci� 
zwracan� przez utworzon� powy�ej funkcj�. Zdefiniuj t� kolumn� jako PERSISTED. 
Prawdopodobnie otrzymasz przy tym b��d. 
4. Zmie� definicj� funkcji tak, aby mo�na by�o j� wykorzysta� jako kolumn� wyliczan� zapisan� na 
dysku wraz z rekordami (PERSISTED) 
5. Pon�w dodawanie nowej kolumny tak, jak opisano to w punkcie 3. Teraz powinno si� to uda�. 
6. Przetestuj tabel� z now� kolumn�. Na zako�czenie usu� kolumn� wyliczan�
*/

CREATE OR ALTER FUNCTION dbo.GetOrderValue(@OrderQty SMALLINT, @UnitPrice MONEY, 
@UnitPriceDiscount MONEY) 
RETURNS MONEY 
WITH SCHEMABINDING
AS 
BEGIN 
 RETURN @OrderQty * (@UnitPrice - @UnitPriceDiscount); 
END 
GO 
 
SELECT dbo.GetOrderValue(OrderQty, UnitPrice, UnitPriceDiscount), * FROM 
Sales.SalesOrderDetail; 

ALTER TABLE Sales.SalesOrderDetail
ADD OrderValue AS dbo.GetOrderValue(OrderQty, UnitPrice, UnitPriceDiscount) PERSISTED;
GO

SELECT dbo.GetOrderValue(OrderQty, UnitPrice, UnitPriceDiscount), * FROM 
Sales.SalesOrderDetail; 

ALTER TABLE Sales.SalesOrderDetail DROP COLUMN OrderValue;