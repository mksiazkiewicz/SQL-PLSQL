-- 1. Get the current date and time
DECLARE @CurrentDateTime DATETIME2;
SET @CurrentDateTime = SYSDATETIME();
SELECT 'Current date and time: ' + CONVERT(NVARCHAR(50), @CurrentDateTime, 120);

SELECT FORMAT (@CurrentDateTime, 'd', 'en-US') AS 'US English Result',
       FORMAT (@CurrentDateTime, 'd', 'no') AS 'Norwegian Result',
       FORMAT (@CurrentDateTime, 'd', 'zu') AS 'Zulu Result',
	   FORMAT (@CurrentDateTime, 'd', 'pl-PL') AS 'Polish Result';

-- 2. Get the SQL Server version
SELECT @@VERSION AS 'SQL Server version',
       @@SERVERNAME AS 'Server name',
	   @@LANGUAGE AS 'Language',
	   @@CONNECTIONS AS 'Login attempts',
	   @@MAX_CONNECTIONS AS 'Max number of connections',
	   @@SPID AS 'My session ID';

-- 3. Get the database name
SELECT  DB_NAME() AS 'Database name', DB_ID() AS 'Database id', DB_ID('tempdb') AS 'Id of tempdb';

-- 4. Retrieve information about tables in the database
SELECT TABLE_NAME, COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo';

-- 5. Retrieve information about indexes in the database
SELECT OBJECT_NAME(object_id) AS TableName, name AS IndexName, *
FROM sys.indexes
WHERE type_desc = 'NONCLUSTERED';

-- 6. Get information about users
SELECT name AS UserName, type_desc AS UserType
FROM sys.database_principals
WHERE type_desc IN ('SQL_USER', 'WINDOWS_USER') AND name <> USER_NAME();

-- 7. Calculate the difference between two dates
DECLARE @StartDate DATE = '2028-01-01';
DECLARE @EndDate DATE = '2028-12-31';
PRINT 'Days between ' + CONVERT(NVARCHAR(10), @StartDate) + ' and ' + CONVERT(NVARCHAR(10), @EndDate) + ': ' +
      CAST(DATEDIFF(DAY, @StartDate, @EndDate) AS NVARCHAR(10));
PRINT 'Hours between ' + CONVERT(NVARCHAR(10), @StartDate) + ' and ' + CONVERT(NVARCHAR(10), @EndDate) + ': ' +
      CAST(DATEDIFF(HOUR, @StartDate, @EndDate) AS NVARCHAR(10));
PRINT 'Minutes between ' + CONVERT(NVARCHAR(10), @StartDate) + ' and ' + CONVERT(NVARCHAR(10), @EndDate) + ': ' +
      CAST(DATEDIFF(MINUTE, @StartDate, @EndDate) AS NVARCHAR(10));
PRINT 'Seconds between ' + CONVERT(NVARCHAR(10), @StartDate) + ' and ' + CONVERT(NVARCHAR(10), @EndDate) + ': ' +
      CAST(DATEDIFF(SECOND, @StartDate, @EndDate) AS NVARCHAR(10));

-- 8. Generate a unique identifier (GUID)
DECLARE @UniqueID UNIQUEIDENTIFIER = NEWID();
PRINT 'Generated unique ID: ' + CAST(@UniqueID AS NVARCHAR(50));

-- 9. Format numeric values
DECLARE @Amount MONEY = 12345.67;
PRINT 'Formatted amount: ' + FORMAT(@Amount, 'C', 'en-US');
PRINT 'Formatted amount: ' + FORMAT(@Amount, 'C', 'de-DE');
PRINT 'Formatted amount: ' + FORMAT(@Amount, 'C', 'pl-PL');

-- 10. Extract the year from a date
DECLARE @SomeDate DATE = '2023-05-15';
PRINT 'Year from ' + CONVERT(NVARCHAR(10), @SomeDate) + ': ' + CAST(YEAR(@SomeDate) AS NVARCHAR(4));

-- 11. Convert a string to uppercase
DECLARE @InputString NVARCHAR(50) = 'Hello, World!';
PRINT 'Uppercase version: ' + UPPER(@InputString);

-- 12. Getting fragmentation information for SQL database
SELECT
    a.index_id,
    NAME AS IndexName,
    avg_fragmentation_in_percent,
    fragment_count,
    avg_fragment_size_in_pages
FROM sys.dm_db_index_physical_stats (
    DB_ID(),
    NULL,
    NULL,
    NULL,
    NULL
) AS a
INNER JOIN sys.indexes b ON a.object_id = b.object_id AND a.index_id = b.index_id;