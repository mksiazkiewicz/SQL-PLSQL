CREATE TYPE SelectedEmployees
AS TABLE
( BusinessEntityID INT,
  RegIn [datetime] NULL,
  RegOut [datetime] NULL
);
GO

DECLARE @dayInOut SelectedEmployees;

INSERT INTO @dayInOut (BusinessEntityID, RegIn, RegOut)
VALUES
  (1, '2033-03-03 7:40', NULL), (2, '2033-03-03 7:50', '2033-03-03 17:04'), 
  (3, '2033-03-03 8:01', '2033-03-03 15:03'), (4, '2033-03-03 8:11', '2033-03-03 15:03');

SELECT * FROM @dayInOut;
GO

CREATE OR ALTER PROCEDURE HumanResources.ImportInOut (@inputTable SelectedEmployees READONLY, @rows INT OUT)
AS 
BEGIN
	IF EXISTS (SELECT * FROM @inputTable WHERE RegIn IS NULL OR RegOut IS NULL OR RegIN>RegOut)
	BEGIN;
	THROW 50011, 'Imported data contains empty in or out fields',1;
	END

	ELSE
	BEGIN
	INSERT INTO HumanResources.InOut (BusinessEntityID, RegIn, RegOut)
	SELECT BusinessEntityID, RegIn, RegOut FROM @inputTable;

	SELECT @rows = @@ROWCOUNT;
	END
END
GO

DECLARE @dayInOut SelectedEmployees;
DECLARE @numberOfRows INT = 0;

INSERT INTO @dayInOut (BusinessEntityID, RegIn, RegOut)
VALUES
  (1, '2033-03-03 7:40', '2033-03-03 14:10'), (2, '2033-03-03 7:50', '2033-03-03 17:04'), 
  (3, '2033-03-03 8:01', '2033-03-03 15:03'), (4, '2033-03-03 8:11', '2033-03-03 15:03');

EXEC HumanResources.ImportInOut @inputTable = @dayInOut, @rows = @numberOfRows OUT;

SELECT @numberOfRows AS'Number of imported rows';
GO

SELECT * FROM HumanResources.InOut 