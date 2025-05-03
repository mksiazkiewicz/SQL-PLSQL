/*1. Przepisz funkcjê z poprzedniego laboratorium tak, aby korzysta³a z multi-statement table-valued 
function.  Nazwij j¹ GetPersonAddress_MSTVF. 
2. SprawdŸ w planie zapytania, ile rekordów jest przewidywanych przez Cardinality Estimator na 
wyjœciu funkcji.
*/

CREATE OR ALTER FUNCTION dbo.GetPersonAddress_MSTVF (@BusinessEntityId INT)
RETURNS
	@ResultTab TABLE (  
	  Id INT, 
	  FirstName NVARCHAR(50), 
	  LastName NVARCHAR(50), 
	  AddressType NVARCHAR(50), 
	  PostalCode NVARCHAR(15), 
	  City NVARCHAR(30), 
	  AddressLine1 NVARCHAR(60), 
	  AddressLine2 NVARCHAR(60))
AS
BEGIN
INSERT INTO @ResultTab
SELECT  
	p.BusinessEntityId, p.FirstName, p.LastName 
	, at.Name AS 'Address Type' 
	, a.PostalCode, a.City, a.AddressLine1, a.AddressLine2 
	FROM Person.Person AS p 
	JOIN Person.BusinessEntityAddress AS bea ON bea.BusinessEntityID=p.BusinessEntityID 
	JOIN Person.AddressType AS at ON at.AddressTypeID = bea.AddressTypeID 
	JOIN Person.Address AS a ON a.AddressID = bea.AddressID 
	WHERE p.BusinessEntityID = @BusinessEntityId
RETURN
END
GO

SELECT * FROM dbo.GetPersonAddress_MSTVF(4025)