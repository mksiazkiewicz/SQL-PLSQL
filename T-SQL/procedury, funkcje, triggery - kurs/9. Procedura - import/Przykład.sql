CREATE TABLE dbo.Inventory
(
  id INT IDENTITY PRIMARY KEY,
  name NVARCHAR(100),
  price DECIMAL(9,2),
  amount INT
);

CREATE TABLE dbo.Errors
(
  import_date DATETIME,
  name NVARCHAR(100),
  price DECIMAL(9,2),
  amount INT,
  PRIMARY KEY (import_date, name)
);
GO

CREATE TYPE ImportData AS TABLE
(
  name NVARCHAR(100) PRIMARY KEY,
  price DECIMAL(9,2),
  amount INT
);
GO

CREATE PROCEDURE dbo.uspImportData
    @Records AS dbo.ImportData READONLY
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.Errors (import_date, name, price, amount)
    SELECT GetDate(), name, price, amount
    FROM @Records
    WHERE price IS NULL OR amount IS NULL;

    INSERT INTO dbo.Inventory(name, price, amount)
    SELECT name, price, amount
    FROM @Records
    WHERE price IS NOT NULL AND amount IS NOT NULL;

END
GO

DECLARE @ImportTab ImportData;
INSERT INTO @ImportTab (name, price, amount)
VALUES
('Bottle A', 12.99, 30),
('Bottle B', 10.99, 10),
('Bottle C', 9.99, NULL),
('Box A', 3, 30),
('Box B', NULL, 30),
('BoX C', 2, 30);

EXEC dbo.uspImportData @Records = @ImportTab

SELECT * FROM dbo.Inventory;
SELECT * FROM dbo.Errors;