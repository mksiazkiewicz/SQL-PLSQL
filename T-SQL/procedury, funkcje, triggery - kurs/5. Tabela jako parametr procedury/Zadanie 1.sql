/*
1. Utwórz typ MemShopOrders odpowiadaj¹cy tabeli z poprzedniego LAB: 
a. ClientId – liczba ca³kowita 
b. OrderDate – DATETIME2 
c. OrderNote typu OrderNote 
2. Napisz procedurê Sales.InsertMultiOrders, która jako parametr wejœciowy przyjmie @OrdersTab - tabelê o typie MemShopOrder. 
Procedura powinna przekopiowaæ zawartoœæ tej tabeli pamiêciowej do fizycznej tabeli ShopOrder. 
3. Zmieñ kod z poprzedniego LAB tak, aby zmienna tabelaryczna by³a typu MemShopOrders. 
Zachowaj kod wstawiaj¹cy do tej pamiêciowej tabeli takie same rekordy, jak w poprzednim LAB 
4. Wywo³aj procedurê Sales.InsertMultiOrder przekazuj¹c do niej przygotowan¹ w poprzednich 
krokach tabelê. 
5. SprawdŸ, czy rekordy zapisane w zmiennej pamiêciowej zosta³y teraz zapisane do tabeli 
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