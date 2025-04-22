/*1. Zdarza siê, ¿e procedurê trzeba wykonaæ dla ka¿dego wiersza w tabeli. Mo¿e to byæ np. proces 
przegl¹daj¹cy informacje o klientach i wysy³aj¹cy ka¿demu klientowi osobno wiadomoœæ email 
prosto z serwera SQL. W przypadku tego LABa przeœledzisz procedurê administracyjn¹, która 
sprawdzi, czy tabele bazy danych siê nie uszkodzi³y.  
2. Informacje o wszystkich tabelach znajdziesz w widoku INFORMATION_SCHEMA_TABLES: 
SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE' 
3. Polecenie sprawdzaj¹ce pojedyncz¹ tabelê mo¿e wygl¹daæ tak: 
DBCC CHECKTABLE ('Sales.SalesTaxRate') 
4. No to zaczynamy pisaæ procedurê, która przejdzie krok po kroku ka¿d¹ tabelê i uruchomi dla niej 
procedurê DBCC CHECKTABLE 
5. Utwórz procedurê o nazwie dbbo.TestTableOneByOne 
CREATE OR ALTER PROCEDURE dbo.TestTableOneByOne 
AS 
BEGIN 
END 
6. Utwórz zmienn¹ tabelaryczn¹ @tab, z kolumn¹ name typu SYSNAME (ten alias jest czêsto 
wykorzystywany do nazywania obiektów w SQL). Przepisz do tej tabeli to, co zwraca zapytanie z 
pkt. 1
7. Napisz pêtlê WHILE, która bêdzie siê wykonywaæ tak d³ugo, jak d³ugo w @tab s¹ rekordy: 
WHILE EXISTS(SELECT * FROM @tab) 
BEGIN 
END 
8. W tej pêtli: 
a. Zadeklaruj zmienn¹ @table_name i zapisz w niej nazwê tabeli znajduj¹c¹ siê w 
pierwszym rekordzie tabeli @tab 
DECLARE @table_name SYSNAME; 
SELECT TOP 1 @table_name = name FROM @tab; 
b. Przygotuj parametry potrzebne do uruchomienia procedury sp_executesql (wiêcej o tej 
procedurze opowiadam w jednej z kolejnych lekcji „Procedury systemowe”). Procedura 
jako argumenty przyjmuje: 
@Command – napis z poleceniem do uruchomienia. W tym napisie mog¹ siê 
pojawiaæ miejsca, które w momencie uruchomienia bêd¹ zamieniane na 
w³aœciwe wartoœci (zobacz poni¿ej) 
@ParamDefinition – napis definiuj¹cy nazwy i typy dynamicznych parametrów, 
które bêd¹ przekazane do wykonania  
DECLARE @command NVARCHAR(MAX) = 'DBCC CHECKTABLE(@table_name)'; 
DECLARE @ParmDefinition NVARCHAR(500);   
SET @ParmDefinition = N'@table_name SYSNAME';   
c. Uruchom procedurê sp_executesql przekazuj¹c do niej @Command, @ParamDefinition 
i @table_name 
EXECUTE sp_executesql @Command, @ParmDefinition, @table_name = @table_name;   
d. Usuñ przetworzony rekord z tabeli @tab 
DELETE FROM @tab WHERE name = @table_name; 
9. Uruchom procedurê i obserwuj jej postêpy na zak³adce Messages.
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