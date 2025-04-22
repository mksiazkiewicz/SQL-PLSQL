CREATE OR ALTER PROCEDURE Person.CountPersons @PersonType NCHAR(2), @Title 
NVARCHAR(8) 
AS 
SELECT DISTINCT PersonType, Title, count(*) FROM PERSON.Person  
WHERE PersonType = @PersonType AND Title = @Title 
GROUP BY PersonType, Title  
GO

EXEC Person.CountPersons 'GC', 'Mr.' ;


SELECT ST.text, QS.execution_count FROM sys.dm_exec_query_stats AS QS  
CROSS APPLY sys.dm_exec_sql_text(QS.sql_handle) as ST 
WHERE ST.text LIKE '%Person.Count%' 

CREATE NONCLUSTERED INDEX Person_Person_PersonType_Title 
ON Person.Person (PersonType,Title) ;


EXEC Person.CountPersons 'GC', 'Mr.' 

SELECT ST.text, QS.execution_count FROM sys.dm_exec_query_stats AS QS  
CROSS APPLY sys.dm_exec_sql_text(QS.sql_handle) as ST 
WHERE ST.text LIKE '%Person.Count%' 

DROP INDEX Person_Person_PersonType_Title ON Person.Person 