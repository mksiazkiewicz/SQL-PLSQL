 SELECT Name, ListPrice, StandardCost From Production.Product 
 WHERE StandardCost * 1.5 >  ListPrice ;
 GO

CREATE OR ALTER FUNCTION Production.GetProfitLevel(@StandardCost money, @ListPrice money)
RETURNS DECIMAL(10,2)
AS
 BEGIN
	DECLARE @Result DECIMAL(10,2) = NULL;
	IF @ListPrice <> 0 
		SET @Result = 1 - @StandardCost / @ListPrice;
	RETURN @Result;
 END;
GO

SELECT 
	p.Name, p.ListPrice, p.StandardCost,
	Production.GetProfitLevel(p.StandardCost, p.ListPrice)
FROM Production.Product p 
WHERE Production.GetProfitLevel(p.StandardCost, p.ListPrice) > 0.5
ORDER BY Production.GetProfitLevel(p.StandardCost, p.ListPrice) DESC;
GO

SELECT OBJECT_NAME(object_id) as 'function_name', execution_count, * FROM sys.dm_exec_function_stats;
GO

SELECT COUNT(*) FROM Production.Product;
GO