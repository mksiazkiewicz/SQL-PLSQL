USE AdventureWorks2017
GO

-- Tworzenie funkcji tabelarycznej 
CREATE FUNCTION GetOrdersByCustomer (@CustomerId INT)
RETURNS TABLE 
AS
RETURN  
(SELECT  so.SalesOrderID, so.OrderDate, so.TotalDue, FirstName, LastName FROM Sales.SalesOrderHeader  so
 INNER JOIN Sales.Customer AS c ON so.CustomerID = c.CustomerID
 INNER JOIN Person.Person AS p ON c.PersonID = p.BusinessEntityID
 WHERE so.CustomerID = @CustomerId)
GO

SELECT * FROM GetOrdersByCustomer(29734)
GO

-- Tworzenie funkcji skalarnej
CREATE FUNCTION GetTotalDueByCustomer(@CustomerId INT)
RETURNS DECIMAL (10,2)
AS
BEGIN
DECLARE @value DECIMAL (10,2)
SELECT @value = SUM(TotalDue) FROM Sales.SalesOrderHeader
WHERE CustomerID=@CustomerId

RETURN @value
END
GO

SELECT dbo.GetTotalDueByCustomer(29734) as total