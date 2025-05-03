/*1. Kolumna wyliczana zaprezentowana na lekcji, wymaga od SQL Server wykonywania obliczenia 
wartoœci tej kolumny zawsze, kiedy u¿ytkownik pobiera dane z tej tabeli. Powoduje to obci¹¿enie 
CPU podczas wykonywania zapytañ, dlatego istnieje mo¿liwoœæ zapisania raz wyznaczonych 
wartoœci na dysk. Takie obliczenie bêdzie wykonane tylko po wykonaniu polecenia INSERT i 
UPDATE, a polecenie SELECT bêdzie jedynie odczytywaæ tê wartoœæ. W poleceniu ALTER TABLE 
ADD COLUMN wystarczy dodaæ s³owo PERSISTED, a wartoœæ bêdzie ju¿ zapisana na dysku. 
2. Utwórz funkcjê, która dla danej iloœci, ceny i rabatu wyznaczy wartoœæ zamówienia. Przetestuj 
wyliczanie wartoœci na tabeli Sales.SalesOrderDetail. Skorzystaj z kodu poni¿ej: 
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
 
3. Do tabeli Sales.SalesOrderDetail dodaj kolumnê OrderValue, która bêdzie wype³niona wartoœci¹ 
zwracan¹ przez utworzon¹ powy¿ej funkcjê. Zdefiniuj tê kolumnê jako PERSISTED. 
Prawdopodobnie otrzymasz przy tym b³¹d. 
4. Zmieñ definicjê funkcji tak, aby mo¿na by³o j¹ wykorzystaæ jako kolumnê wyliczan¹ zapisan¹ na 
dysku wraz z rekordami (PERSISTED) 
5. Ponów dodawanie nowej kolumny tak, jak opisano to w punkcie 3. Teraz powinno siê to udaæ. 
6. Przetestuj tabelê z now¹ kolumn¹. Na zakoñczenie usuñ kolumnê wyliczan¹
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