 sp_databases – wyświetla listę baz danych na serwerze 

 sp_helpdb – wyświetla więcej informacji o bazach danych 

 sp_tables – wyświetla listę tabel w bazie danych 

 sp_stored_procedures – wyświetla listę procedur składowanych 

 sp_help_trigger <tabela> - wyświetla informacje o triggerach skonfigurowanych dla 
wybranej tabeli 

 sp_configure – wyświetla i modyfikuje ustawienia systemowe 

 xp_logininfo – wyświetla informacje o użytkownikach, którzy mogą uzyskiwać dostęp do 
serwera poprzez członkostwo w grupie windowsowej 

 sp_who2 – wyświetla informacje o aktualnie trwających sesjach użytkowników 

Specyficzna procedura, która pozwala na wykonanie poleceń SQL zapisanych w postaci tekstu. 
Aby ustrzec się problemu SQL Injection ta procedura potrafi rozpoznać, co jest parametrem, a co 
kodem i dzięki temu zabezpiecza serwer przed uruchomieniem złośliwego kodu. 

● Pracując z sp_executesql korzystamy z : 
o Zmiennych, które przechowują wartości przekazane od użytkownika 
o Komendy SQL z szablonowym zapytaniem 
o Definicją parametrów z nazwą parametru i jej typem 

DECLARE @IntVariable INT;   
DECLARE @SQLString NVARCHAR(500);   
DECLARE @ParmDefinition NVARCHAR(500);   
DECLARE @max_title VARCHAR(30);   
SET @IntVariable = 197;   
SET @SQLString = N'SELECT @max_titleOUT = max(JobTitle)    
FROM HumanResources.Employee   
WHERE BusinessEntityID = @level';   
SET @ParmDefinition = N'@level TINYINT, @max_titleOUT VARCHAR(30) OUTPUT';   
EXECUTE sp_executesql @SQLString, @ParmDefinition, @level = @IntVariable, 
@max_titleOUT=@max_title OUTPUT;   
SELECT @max_title; 