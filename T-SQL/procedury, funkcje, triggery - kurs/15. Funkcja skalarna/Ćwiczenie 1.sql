/*1. Napisz funkcjê, która wyznaczy nowo wymyœlony przez dyrektora HR wskaŸnik lojalnoœci 
pracownika. Funkcja jako argumenty ma przyj¹æ 3 daty: BirthDate, HireDate i ReportDate. 
WskaŸnik ma byæ wyliczany w nastêpuj¹cy sposób: 
a. Wyznacz ró¿nicê w dniach miêdzy dat¹ urodzenia (BirthDate), a dat¹ zatrudnienia 
(HireDate) 
b. Wyznacz ró¿nicê miêdzy dat¹ zatrudnienia (HireDate) a dat¹ przes³an¹ jako argument 
ReportDate 
c. Zwróæ liczbê bêd¹c¹ wynikiem dzielenia liczby wyznaczonej w punkcie b przez liczbê 
wyliczon¹ w punkcie b 
2. Wyœwietl informacje o pracownikach z tabeli HumanResources.Employee, wraz z wskaŸnikiem 
lojalnoœci. Jako argumenty przeka¿ BirthDate, HireDate i datê dzisiejsz¹.
*/

--1
CREATE OR ALTER FUNCTION dbo.HR_Rate (@BirthDate DATE, @HireDate DATE, @ReportDate DATE)
RETURNS DECIMAL (10,2)
AS 
BEGIN
	DECLARE @result_a DECIMAL (10,2) = NULL;
	SET @result_a = DATEDIFF(DAY,@BirthDate,@HireDate);

	DECLARE @result_b DECIMAL (10,2) = NULL;
	SET @result_b = DATEDIFF(DAY, @HireDate, @ReportDate);

	RETURN @result_b / @result_a;
END;
GO

--2
SELECT BusinessEntityID, 
JobTitle, 
BirthDate, 
HireDate,
GETDATE() as ReportDate,
dbo.HR_Rate(BirthDate, HireDate,GETDATE() )  
FROM HumanResources.Employee;