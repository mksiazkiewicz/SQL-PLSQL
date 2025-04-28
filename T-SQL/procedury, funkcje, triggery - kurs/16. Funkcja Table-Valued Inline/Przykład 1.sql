SELECT p.name, 
       (sod.UnitPrice - sod.UnitPriceDiscount) * sod.OrderQty AS order_value,
	   soh.SalesOrderNumber, soh.CurrencyRateID
FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
JOIN Production.Product p ON p.ProductID = sod.ProductID
WHERE
	soh.OrderDate BETWEEN '2011-05-01' AND '2011-05-31'
	AND TerritoryID = 6;
GO

--W funkcji inline nie wolno u¿ywaæ BEGIN/END. 
--Deklaruj¹c tak¹ funkcjê zaznaczamy, ¿e funkcja zwraca tabelê pisz¹c RETURNS TABLE

CREATE OR ALTER FUNCTION Sales.GetOrderValue (@DateStart DATETIME, @DateStop DATETIME, @TerritoryId INT = 6)
RETURNS TABLE
AS
RETURN 
	SELECT p.name, 
		   soh.OrderDate,
		   (sod.UnitPrice - sod.UnitPriceDiscount) * sod.OrderQty AS order_value,
		   soh.SalesOrderNumber, soh.CurrencyRateID
	FROM Sales.SalesOrderDetail sod
	JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
	JOIN Production.Product p ON p.ProductID = sod.ProductID
	WHERE
		soh.OrderDate BETWEEN @DateStart AND @DateStop
		AND TerritoryID = @TerritoryId;
GO

SELECT * FROM Sales.GetOrderValue('2011-05-01', '2011-05-31', 4);

SELECT gov.*, cr.FromCurrencyCode, cr.ToCurrencyCode, cr.AverageRate
FROM Sales.GetOrderValue('2011-05-01', '2011-05-31', 6) AS gov
JOIN Sales.CurrencyRate AS cr ON cr.CurrencyRateID = gov.CurrencyRateID

SELECT gov.*, cr.FromCurrencyCode, cr.ToCurrencyCode, cr.AverageRate
FROM Sales.CurrencyRate AS cr 
JOIN Sales.GetOrderValue('2011-05-01', '2011-05-31', 6) AS gov
	 ON cr.CurrencyRateID = gov.CurrencyRateID;

--Jeœli funkcja inline ma byæ wykorzystana w JOIN i funkcja ta korzysta z dynamicznej wartoœci 
--parametrów pochodz¹cych z kolumn tabeli zewnêtrznej, to nale¿y u¿yæ CROSS APPLY 
SELECT st.Name, st.[Group], gov.*
FROM Sales.SalesTerritory AS st 
CROSS APPLY Sales.GetOrderValue('2011-05-01', '2012-05-31', st.TerritoryID) AS gov
	WHERE st.Name in ('France', 'Germany', 'United Kingdom');