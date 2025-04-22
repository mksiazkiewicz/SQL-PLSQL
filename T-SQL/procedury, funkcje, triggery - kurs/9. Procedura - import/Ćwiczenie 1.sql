/*
1. Szef sprzeda¿y uzna³, ¿e opisy produktów w tabeli Production.Product s¹ niekompletne. Czêsto 
brakuje koloru, klasy lub stylu. Przygotujemy procedurê, która wydobêdzie z tabeli 
Production.Product identyfikatory tych produktów, którym czegoœ brakuje w opisie. Dziêki temu 
bêdzie mo¿na zwróciæ do dzia³u marketingu listê produktów wymagaj¹cych lepszego opisania. 
Procedura ma byæ elastyczna i ma zbieraæ informacje o rekordach, w których brakuje Color, Class 
lub Style. 
2. Utwórz tabelê, w której bêdziemy przechowywaæ informacje o wybrakowanych rekordach.  
3. Utwórz procedurê, Production.FindMissingInfo, która przyjmuje trzy argumenty: 
a. @CheckColor typ BIT, domyœlnie 0. Jeœli jest tu wartoœæ 1, to nale¿y odnajdowaæ rekordy 
z brakuj¹cym kolorem 
b. @CheckClass – typ BIT, domyœlnie 0. Jeœli jest tu wartoœæ 1, to nale¿y odnajdowaæ 
rekordy z brakuj¹c¹ klas¹ 
c. @CheckStyle – typ BIT, domyœlnie 0. Jeœli jest tu wartoœæ 1, to nale¿y odnajdowaæ 
rekordy z brakuj¹cym stylem 
4. Napisz cia³o procedury, w którym: 
a. Usuniemy wszystkie rekordy z tabeli Production.ProductMissingInfo 
b. Przepiszemy z Production.Product, te rekordy, które 
i. maj¹ color null, jeœli zmienna @CheckColor ma wartoœæ 1 
ii. maj¹ class null, jeœli zmienna @CheckClass ma wartoœæ 1  
iii. maj¹ style null, jeœli zmienna @CheckStyle ma wartoœæ 1 
5. Korzystaj¹c z procedury Production.FindMissingInfo znajdŸ te produkty, które nie maj¹ 
wype³nionej kolumny z kolorem -- Checking only products with missing Color 
6. Upewnij siê, ¿e w wyniku pierwszego wszystkie rekordy w 
kolumnie Color maj¹ wartoœæ NULL, a w wyniku drugiego ¿aden rekord nie ma w tej kolumnie 
wartoœci NULL. 
7. Korzystaj¹c z procedury Production.FindMissingInfo znajdŸ te produkty, które nie maj¹ 
wype³nionej kolumny ze stylem 
8. Wykonaj znowu zapytanie testuj¹ce tak jak w kroku 6 
9. Korzystaj¹c z procedury Production.FindMissingInfo znajdŸ te produkty, które nie maj¹ 
wype³nionej kolumny z kolorem lub z klas¹ 
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
