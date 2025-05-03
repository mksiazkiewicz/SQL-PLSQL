SELECT ProductID, Name, StandardCost, ListPrice, SellEndDate 
FROM Production.Product
WHERE ListPrice > 0  OR StandardCost > 0;
GO

CREATE OR ALTER FUNCTION GetNewPrice(@ListPrice MONEY, @StandardCost MONEY, @SellEndDate DATETIME, @Ratio DECIMAL(5,2))
RETURNS MONEY
WITH SCHEMABINDING
AS
BEGIN
	DECLARE @NewPrice MONEY;

	IF @SellEndDate IS NULL
	BEGIN
		IF @ListPrice < @StandardCost * @Ratio
			SET @NewPrice = @StandardCost * @Ratio;
		ELSE
			SET @NewPrice = @ListPrice;
	END

	RETURN @NewPrice;
END;
GO

SELECT ProductID, Name, StandardCost, ListPrice, SellEndDate, 
	dbo.GetNewPrice(ListPrice, StandardCost, SellEndDate, 1.5) AS NewPrice_calc
FROM Production.Product 
WHERE ListPrice > 0  OR StandardCost > 0;
GO

ALTER TABLE Production.Product
ADD NewPrice AS dbo.GetNewPrice(ListPrice, StandardCost, SellEndDate, 1.5);
GO

SELECT ProductID, Name, StandardCost, ListPrice, SellEndDate, 
	dbo.GetNewPrice(ListPrice, StandardCost, SellEndDate, 1.5) AS NewPrice_calc,
	NewPrice
FROM Production.Product 
WHERE ListPrice > 0  OR StandardCost > 0;
GO

CREATE INDEX Product_idx_newprice ON Production.Product(NewPrice);
GO

DROP FUNCTION dbo.GetNewPrice;
GO

ALTER TABLE Production.Product DROP COLUMN NewPrice;
GO


CREATE OR ALTER FUNCTION GetNewPrice(@ListPrice MONEY, @StandardCost MONEY, @SellEndDate DATETIME, @Ratio DECIMAL(5,2))
RETURNS MONEY
WITH SCHEMABINDING
AS
BEGIN
	DECLARE @NewPrice MONEY;

	IF @SellEndDate IS NULL
	BEGIN
		IF @ListPrice < @StandardCost * @Ratio
			SET @NewPrice = @StandardCost * @Ratio;
		ELSE
			SET @NewPrice = @ListPrice;
	END

	RETURN @NewPrice;
END;
GO

ALTER TABLE Production.Product
ADD NewPrice AS dbo.GetNewPrice(ListPrice, StandardCost, SellEndDate, 1.5);
GO

SELECT ProductID, Name, StandardCost, ListPrice, SellEndDate, 
	dbo.GetNewPrice(ListPrice, StandardCost, SellEndDate, 1.5) AS NewPrice_calc,
	NewPrice
FROM Production.Product 
WHERE ListPrice > 0  OR StandardCost > 0;
GO

CREATE INDEX Product_idx_newprice ON Production.Product(NewPrice);
GO

DROP FUNCTION dbo.GetNewPrice;
ALTER TABLE Production.Product DROP COLUMN NewPrice;
DROP INDEX Product_idx_newprice ON Production.Product;