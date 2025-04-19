/*
1. Utw�rz typ MemShopOrders odpowiadaj�cy tabeli z poprzedniego LAB: 
a. ClientId � liczba ca�kowita 
b. OrderDate � DATETIME2 
c. OrderNote typu OrderNote 
2. Napisz procedur� Sales.InsertMultiOrders, kt�ra jako parametr wej�ciowy przyjmie @OrdersTab - tabel� o typie MemShopOrder. 
Procedura powinna przekopiowa� zawarto�� tej tabeli pami�ciowej do fizycznej tabeli ShopOrder. 
3. Zmie� kod z poprzedniego LAB tak, aby zmienna tabelaryczna by�a typu MemShopOrders. 
Zachowaj kod wstawiaj�cy do tej pami�ciowej tabeli takie same rekordy, jak w poprzednim LAB 
4. Wywo�aj procedur� Sales.InsertMultiOrder przekazuj�c do niej przygotowan� w poprzednich 
krokach tabel�. 
5. Sprawd�, czy rekordy zapisane w zmiennej pami�ciowej zosta�y teraz zapisane do tabeli 
Sales.ShopOrder*/
CREATE TYPE OrderNote FROM NVARCHAR(MAX); 

--1
CREATE TYPE MemShopOrders 
AS TABLE
(ClientId INT,
OrderDate DATETIME2,
OrderNote OrderNote 
);

--2
CREATE OR ALTER PROCEDURE Sales.InsertMultiOrders (@OrdersTab MemShopOrders READONLY)
AS
BEGIN
INSERT INTO Sales.ShopOrder(ClientId, OrderDate, OrderNote) 
SELECT ClientId,OrderDate,OrderNote FROM @OrdersTab
END;

--3
DECLARE @table MemShopOrders;
INSERT INTO @table (ClientId,OrderDate,OrderNote)
VALUES (20, SYSDATETIME(), 'black and white please'), (21, SYSDATETIME(), '');

--4
EXEC Sales.InsertMultiOrders @OrdersTab=@table;

--5

SELECT * FROM Sales.ShopOrder