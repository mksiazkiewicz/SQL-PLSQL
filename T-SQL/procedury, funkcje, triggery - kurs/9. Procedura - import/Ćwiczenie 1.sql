/*
1. Szef sprzeda�y uzna�, �e opisy produkt�w w tabeli Production.Product s� niekompletne. Cz�sto 
brakuje koloru, klasy lub stylu. Przygotujemy procedur�, kt�ra wydob�dzie z tabeli 
Production.Product identyfikatory tych produkt�w, kt�rym czego� brakuje w opisie. Dzi�ki temu 
b�dzie mo�na zwr�ci� do dzia�u marketingu list� produkt�w wymagaj�cych lepszego opisania. 
Procedura ma by� elastyczna i ma zbiera� informacje o rekordach, w kt�rych brakuje Color, Class 
lub Style. 
2. Utw�rz tabel�, w kt�rej b�dziemy przechowywa� informacje o wybrakowanych rekordach.  
3. Utw�rz procedur�, Production.FindMissingInfo, kt�ra przyjmuje trzy argumenty: 
a. @CheckColor typ BIT, domy�lnie 0. Je�li jest tu warto�� 1, to nale�y odnajdowa� rekordy 
z brakuj�cym kolorem 
b. @CheckClass � typ BIT, domy�lnie 0. Je�li jest tu warto�� 1, to nale�y odnajdowa� 
rekordy z brakuj�c� klas� 
c. @CheckStyle � typ BIT, domy�lnie 0. Je�li jest tu warto�� 1, to nale�y odnajdowa� 
rekordy z brakuj�cym stylem 
4. Napisz cia�o procedury, w kt�rym: 
a. Usuniemy wszystkie rekordy z tabeli Production.ProductMissingInfo 
b. Przepiszemy z Production.Product, te rekordy, kt�re 
i. maj� color null, je�li zmienna @CheckColor ma warto�� 1 
ii. maj� class null, je�li zmienna @CheckClass ma warto�� 1  
iii. maj� style null, je�li zmienna @CheckStyle ma warto�� 1 
5. Korzystaj�c z procedury Production.FindMissingInfo znajd� te produkty, kt�re nie maj� 
wype�nionej kolumny z kolorem -- Checking only products with missing Color 
6. Upewnij si�, �e w wyniku pierwszego wszystkie rekordy w 
kolumnie Color maj� warto�� NULL, a w wyniku drugiego �aden rekord nie ma w tej kolumnie 
warto�ci NULL. 
7. Korzystaj�c z procedury Production.FindMissingInfo znajd� te produkty, kt�re nie maj� 
wype�nionej kolumny ze stylem 
8. Wykonaj znowu zapytanie testuj�ce tak jak w kroku 6 
9. Korzystaj�c z procedury Production.FindMissingInfo znajd� te produkty, kt�re nie maj� 
wype�nionej kolumny z kolorem lub z klas� 
*/
--2
CREATE TABLE Production.ProductMissingInfo (ProductID INT);
GO
--3, 4
CREATE OR ALTER PROCEDURE Production.FindMissingInfo
	@CheckColor BIT = 0,
	@CheckClass BIT = 0,
	@CheckStyle BIT = 0
AS
BEGIN
	DELETE FROM Production.ProductMissingInfo;
	INSERT INTO Production.ProductMissingInfo(ProductID)
	SELECT ProductId FROM Production.Product
	WHERE (Color IS NULL AND @CheckColor=1) OR (Class IS NULL AND @CheckClass=1) OR (Style IS NULL AND @CheckStyle=1);

END;
GO
--5
EXEC Production.FindMissingInfo @CheckColor = 1;
GO
--6
SELECT ProductID, Color, Class, Style FROM Production.Product AS p  
WHERE EXISTS (SELECT * FROM Production.ProductMissingInfo AS i WHERE i.ProductID = 
p.ProductID); 
SELECT ProductID, Color, Class, Style FROM Production.Product AS p  
WHERE NOT EXISTS (SELECT * FROM Production.ProductMissingInfo AS i WHERE 
i.ProductID = p.ProductID); 

--7
EXEC Production.FindMissingInfo @CheckStyle=1;
GO

--8
SELECT ProductID, Color, Class, Style FROM Production.Product AS p  
WHERE EXISTS (SELECT * FROM Production.ProductMissingInfo AS i WHERE i.ProductID = 
p.ProductID); 
SELECT ProductID, Color, Class, Style FROM Production.Product AS p  
WHERE NOT EXISTS (SELECT * FROM Production.ProductMissingInfo AS i WHERE 
i.ProductID = p.ProductID); 

--9
EXEC Production.FindMissingInfo @CheckColor=1, @CheckClass=1; 
