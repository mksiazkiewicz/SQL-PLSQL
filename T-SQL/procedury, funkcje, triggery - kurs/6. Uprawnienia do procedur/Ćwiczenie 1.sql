/*
1. Oto procedura, jaka b�dzie wykorzystywana przez ksi�gowego. Utw�rz j�: 
CREATE OR ALTER PROCEDURE Sales.GetSalesInfo
AS
BEGIN
	SELECT ClientId, COUNT(*) FROM Sales.ShopOrder
	GROUP BY ClientId
END
GO
2. Frank to ksi�gowy i powinien m�c uruchamia� procedur� i liczy�, ile zam�wie� z�o�y� ka�dy 
klient, dlatego: 
a. Utw�rz u�ytkownika frank. Mo�esz skorzysta� z konta u�ytkownika bez loginu 
(WITHOUT LOGIN) 
b. Utw�rz rol� accounting 
c. Przypisz franka do roli accounting 
d. Nadaj roli accounting uprawnienie execute na poziomie ca�ego schematu Sales 
3. Sprawd�, czy skonfigurowane uprawnienia dzia�aj� dla franka: 
a. Prze��cz si� w konto franka (skorzystaj z execute as user) 
b. Sprawd�, czy rzeczywi�cie pracujesz teraz w kontek�cie franka 
c. Wykonaj procedur�. Powinno si� uda� 
d. Napisz zapytanie bezpo�rednio do tabeli Sales.ShopOrder. Nie powinno si� uda� 
zobaczy� danych w tabeli 
e. Prze��cz si� do swojej oryginalnej to�samo�ci. */

--1
CREATE OR ALTER PROCEDURE Sales.GetSalesInfo
AS
BEGIN
	SELECT ClientId, COUNT(*) FROM Sales.ShopOrder
	GROUP BY ClientId
END
GO

--2
CREATE USER frank WITHOUT LOGIN;
CREATE ROLE accounting;
ALTER ROLE accounting ADD MEMBER frank;
GRANT EXECUTE ON SCHEMA::Sales TO accounting;


--3
EXECUTE AS USER='frank';
SELECT USER_NAME();
EXEC Sales.GetSalesInfo;
SELECT * FROM Sales.ShopOrder;
REVERT
