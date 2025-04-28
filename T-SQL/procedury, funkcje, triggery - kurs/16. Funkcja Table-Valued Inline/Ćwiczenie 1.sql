/*1. Napisz funkcj� dbo.GetPrsonAddress typu inline, kt�ra dla zadanego BusinessEntityId zwr�ci 
rekord opisuj�cy adres tej osoby. Oto zapytanie, jakie powinno by� umieszczone w tej funkcji: 
SELECT  
p.BusinessEntityId, p.FirstName, p.LastName 
, at.Name AS 'Address Type' 
, a.PostalCode, a.City, a.AddressLine1, a.AddressLine2 
FROM Person.Person AS p 
JOIN Person.BusinessEntityAddress AS bea ON bea.BusinessEntityID=p.BusinessEntityID 
JOIN Person.AddressType AS at ON at.AddressTypeID = bea.AddressTypeID 
JOIN Person.Address AS a ON a.AddressID = bea.AddressID 
WHERE p.BusinessEntityID = 4045; 
2. Wywo�aj funkcj� dla BusinessEntityId = 4045 */

CREATE OR ALTER FUNCTION dbo.GetPrsonAddress (@BusinessEntityId INT) 
RETURNS TABLE 
AS
RETURN 
	SELECT  
	p.BusinessEntityId, p.FirstName, p.LastName 
	, at.Name AS 'Address Type' 
	, a.PostalCode, a.City, a.AddressLine1, a.AddressLine2 
	FROM Person.Person AS p 
	JOIN Person.BusinessEntityAddress AS bea ON bea.BusinessEntityID=p.BusinessEntityID 
	JOIN Person.AddressType AS at ON at.AddressTypeID = bea.AddressTypeID 
	JOIN Person.Address AS a ON a.AddressID = bea.AddressID 
	WHERE p.BusinessEntityID = @BusinessEntityId
GO

SELECT * FROM dbo.GetPrsonAddress(4045)