/*
1. Oto procedura, jaka bêdzie wykorzystywana przez ksiêgowego. Utwórz j¹: 
CREATE OR ALTER PROCEDURE Sales.GetSalesInfo
AS
BEGIN
	SELECT ClientId, COUNT(*) FROM Sales.ShopOrder
	GROUP BY ClientId
END
GO
2. Frank to ksiêgowy i powinien móc uruchamiaæ procedurê i liczyæ, ile zamówieñ z³o¿y³ ka¿dy 
klient, dlatego: 
a. Utwórz u¿ytkownika frank. Mo¿esz skorzystaæ z konta u¿ytkownika bez loginu 
(WITHOUT LOGIN) 
b. Utwórz rolê accounting 
c. Przypisz franka do roli accounting 
d. Nadaj roli accounting uprawnienie execute na poziomie ca³ego schematu Sales 
3. SprawdŸ, czy skonfigurowane uprawnienia dzia³aj¹ dla franka: 
a. Prze³¹cz siê w konto franka (skorzystaj z execute as user) 
b. SprawdŸ, czy rzeczywiœcie pracujesz teraz w kontekœcie franka 
c. Wykonaj procedurê. Powinno siê udaæ 
d. Napisz zapytanie bezpoœrednio do tabeli Sales.ShopOrder. Nie powinno siê udaæ 
zobaczyæ danych w tabeli 
e. Prze³¹cz siê do swojej oryginalnej to¿samoœci. */

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
