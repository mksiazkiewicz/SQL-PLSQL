/*1. Napisz funkcj�, kt�ra wyznaczy nowo wymy�lony przez dyrektora HR wska�nik lojalno�ci 
pracownika. Funkcja jako argumenty ma przyj�� 3 daty: BirthDate, HireDate i ReportDate. 
Wska�nik ma by� wyliczany w nast�puj�cy spos�b: 
a. Wyznacz r�nic� w dniach mi�dzy dat� urodzenia (BirthDate), a dat� zatrudnienia 
(HireDate) 
b. Wyznacz r�nic� mi�dzy dat� zatrudnienia (HireDate) a dat� przes�an� jako argument 
ReportDate 
c. Zwr�� liczb� b�d�c� wynikiem dzielenia liczby wyznaczonej w punkcie b przez liczb� 
wyliczon� w punkcie b 
2. Wy�wietl informacje o pracownikach z tabeli HumanResources.Employee, wraz z wska�nikiem 
lojalno�ci. Jako argumenty przeka� BirthDate, HireDate i dat� dzisiejsz�.
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