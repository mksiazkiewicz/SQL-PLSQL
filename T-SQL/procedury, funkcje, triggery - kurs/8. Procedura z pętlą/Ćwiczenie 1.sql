/*1. Zdarza si�, �e procedur� trzeba wykona� dla ka�dego wiersza w tabeli. Mo�e to by� np. proces 
przegl�daj�cy informacje o klientach i wysy�aj�cy ka�demu klientowi osobno wiadomo�� email 
prosto z serwera SQL. W przypadku tego LABa prze�ledzisz procedur� administracyjn�, kt�ra 
sprawdzi, czy tabele bazy danych si� nie uszkodzi�y.  
2. Informacje o wszystkich tabelach znajdziesz w widoku INFORMATION_SCHEMA_TABLES: 
SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE' 
3. Polecenie sprawdzaj�ce pojedyncz� tabel� mo�e wygl�da� tak: 
DBCC CHECKTABLE ('Sales.SalesTaxRate') 
4. No to zaczynamy pisa� procedur�, kt�ra przejdzie krok po kroku ka�d� tabel� i uruchomi dla niej 
procedur� DBCC CHECKTABLE 
5. Utw�rz procedur� o nazwie dbbo.TestTableOneByOne 
CREATE OR ALTER PROCEDURE dbo.TestTableOneByOne 
AS 
BEGIN 
END 
6. Utw�rz zmienn� tabelaryczn� @tab, z kolumn� name typu SYSNAME (ten alias jest cz�sto 
wykorzystywany do nazywania obiekt�w w SQL). Przepisz do tej tabeli to, co zwraca zapytanie z 
pkt. 1
7. Napisz p�tl� WHILE, kt�ra b�dzie si� wykonywa� tak d�ugo, jak d�ugo w @tab s� rekordy: 
WHILE EXISTS(SELECT * FROM @tab) 
BEGIN 
END 
8. W tej p�tli: 
a. Zadeklaruj zmienn� @table_name i zapisz w niej nazw� tabeli znajduj�c� si� w 
pierwszym rekordzie tabeli @tab 
DECLARE @table_name SYSNAME; 
SELECT TOP 1 @table_name = name FROM @tab; 
b. Przygotuj parametry potrzebne do uruchomienia procedury sp_executesql (wi�cej o tej 
procedurze opowiadam w jednej z kolejnych lekcji �Procedury systemowe�). Procedura 
jako argumenty przyjmuje: 
@Command � napis z poleceniem do uruchomienia. W tym napisie mog� si� 
pojawia� miejsca, kt�re w momencie uruchomienia b�d� zamieniane na 
w�a�ciwe warto�ci (zobacz poni�ej) 
@ParamDefinition � napis definiuj�cy nazwy i typy dynamicznych parametr�w, 
kt�re b�d� przekazane do wykonania  
DECLARE @command NVARCHAR(MAX) = 'DBCC CHECKTABLE(@table_name)'; 
DECLARE @ParmDefinition NVARCHAR(500);   
SET @ParmDefinition = N'@table_name SYSNAME';   
c. Uruchom procedur� sp_executesql przekazuj�c do niej @Command, @ParamDefinition 
i @table_name 
EXECUTE sp_executesql @Command, @ParmDefinition, @table_name = @table_name;   
d. Usu� przetworzony rekord z tabeli @tab 
DELETE FROM @tab WHERE name = @table_name; 
9. Uruchom procedur� i obserwuj jej post�py na zak�adce Messages.
*/

SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE' 
DBCC CHECKTABLE ('Sales.SalesTaxRate') 
GO 
CREATE OR ALTER PROCEDURE dbo.TestTableOneByOne 
AS 
BEGIN 
DECLARE @tab TABLE (name SYSNAME) 
INSERT INTO @tab SELECT TABLE_SCHEMA + '.' + TABLE_NAME FROM 
INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE'; 
WHILE EXISTS(SELECT * FROM @tab) 
BEGIN 
DECLARE @table_name SYSNAME; 
SELECT TOP 1 @table_name = name FROM @tab; 
DECLARE @command NVARCHAR(MAX) = 'DBCC CHECKTABLE(@table_name)'; 
DECLARE @ParmDefinition NVARCHAR(500);   
SET @ParmDefinition = N'@table_name SYSNAME';   
EXECUTE sp_executesql @Command, @ParmDefinition, @table_name = 
@table_name;   
END 
END; 
GO 
DELETE FROM @tab WHERE name = @table_name; 
EXECUTE dbo.TestTableOneByOne