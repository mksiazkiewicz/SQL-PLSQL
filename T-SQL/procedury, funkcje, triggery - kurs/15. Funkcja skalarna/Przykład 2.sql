DECLARE @Counter_1 INT;
 SELECT @Counter_1 = execution_count 
	FROM sys.dm_exec_function_stats 
	WHERE OBJECT_NAME(object_id)='GetProfitLevel';

 SELECT 
	p.Name, p.ListPrice, p.StandardCost
	,Production.GetProfitLevel(p.StandardCost, p.ListPrice)
 FROM Production.Product p 
 WHERE Production.GetProfitLevel(p.StandardCost, p.ListPrice) > 0.5
 ORDER BY Production.GetProfitLevel(p.StandardCost, p.ListPrice) DESC

 DECLARE @Counter_2 INT;
 SELECT @Counter_2 = execution_count 
	FROM sys.dm_exec_function_stats 
	WHERE OBJECT_NAME(object_id)='GetProfitLevel';

SELECT @Counter_2 - @Counter_1 AS 'number of executions';