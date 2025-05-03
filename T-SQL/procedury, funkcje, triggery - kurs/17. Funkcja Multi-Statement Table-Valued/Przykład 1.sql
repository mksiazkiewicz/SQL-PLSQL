SELECT 'HumanResources.Department', Name FROM HumanResources.Department;

SELECT 'Sales.Territory', 'Office: '+ Name FROM Sales.SalesTerritory ;

SELECT DISTINCT 'VendorAddress', 'Vendor: '+ sp.Name
FROM Purchasing.Vendor AS v
JOIN Person.BusinessEntityAddress AS bea ON bea.BusinessEntityID = v.BusinessEntityID
JOIN Person.Address AS a ON a.AddressID = bea.AddressID
JOIN Person.StateProvince AS sp ON sp.StateProvinceID = a.StateProvinceID
GO

CREATE OR ALTER FUNCTION Person.GetLocations(@ShowVendors BIT = 0)
RETURNS  
  @ResultTab TABLE(ID INT IDENTITY, Source VARCHAR(100), Name NVARCHAR(100))
AS
BEGIN

  INSERT INTO @ResultTab
  SELECT 'HumanResources.Department', Name FROM HumanResources.Department;

  INSERT INTO @ResultTab
  SELECT 'Sales.Territory', 'Office: '+ Name FROM Sales.SalesTerritory ;

  IF @ShowVendors = 1 
	INSERT INTO @ResultTab
	SELECT DISTINCT 'VendorAddress', 'Vendor: '+ sp.Name
	FROM Purchasing.Vendor AS v
	JOIN Person.BusinessEntityAddress AS bea ON bea.BusinessEntityID = v.BusinessEntityID
	JOIN Person.Address AS a ON a.AddressID = bea.AddressID
	JOIN Person.StateProvince AS sp ON sp.StateProvinceID = a.StateProvinceID

  RETURN
END
GO

SELECT * FROM Person.GetLocations(DEFAULT);

SELECT * FROM Person.GetLocations(1);
GO

CREATE OR ALTER FUNCTION Production.GetOrderAmount_multi(@ProductId INT)
RETURNS  
  @ResultTab TABLE(ProductId INT, Amount DECIMAL(10,3))
AS
BEGIN
  INSERT INTO @ResultTab
	  SELECT sod.ProductId, SUM(sod.OrderQty*sod.UnitPrice) 
	  FROM Sales.SalesOrderDetail AS sod
	  WHERE sod.ProductID = @ProductId
	  GROUP BY sod.ProductID;

  RETURN
END
GO

SELECT p.Name, goa.Amount
FROM Production.Product AS p
CROSS APPLY Production.GetOrderAmount_multi(p.ProductID) AS goa
GO

CREATE OR ALTER FUNCTION Production.GetOrderAmount_inline(@ProductId INT)
RETURNS TABLE
AS
RETURN
	  SELECT sod.ProductId, SUM(sod.OrderQty*sod.UnitPrice) AS Amount
	  FROM Sales.SalesOrderDetail AS sod
	  WHERE sod.ProductID = @ProductId
	  GROUP BY sod.ProductID;
GO

SELECT p.Name, goa.Amount
FROM Production.Product AS p
CROSS APPLY Production.GetOrderAmount_inline(p.ProductID) AS goa
GO