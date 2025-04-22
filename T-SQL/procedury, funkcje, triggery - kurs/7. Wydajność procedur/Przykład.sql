SET STATISTICS IO ON

SELECT * FROM Person.Address
WHERE PostalCode='92173'
--218 / 4

SELECT * FROM Person.Address
WHERE PostalCode='98168'
--346 / 346

CREATE NONCLUSTERED INDEX IX_Person_Address_PostalCode
ON Person.Address(PostalCode)
GO

CREATE PROCEDURE Person.GetByPostalCode @vPostalCode VARCHAR(6)
AS
SELECT * FROM Person.Address
WHERE PostalCode=@vPostalCode
GO

EXECUTE Person.GetByPostalCode '92173'
--4
EXECUTE Person.GetByPostalCode '98168'
--433
EXECUTE Person.GetByPostalCode '98168' WITH RECOMPILE --u¿ywane ka¿dorazowo przy uruchomieniu
--346
EXECUTE sp_recompile 'Person.GetByPostalCode' --plan zapytania w cache zostaje wycofany
GO

ALTER PROCEDURE Person.GetByPostalCode @vPostalCode VARCHAR(6)
--WITH RECOMPILE -- z ka¿dym uruchomieniem na nowo rekompilowana
AS
SELECT * FROM Person.Address
WHERE PostalCode=@vPostalCode
--OPTION (RECOMPILE) -- jako hint do pojedynczego zapytania
OPTION (OPTIMIZE FOR (@vPostalCode = '92173')) -- dla jakiej wartoœci parametru optymalizowanie
GO