CREATE TABLE Production.LockedCategories
(
  LockedCategoryID INT PRIMARY KEY,
  LockReason NVARCHAR(MAX)
);
GO

SELECT * FROM Production.ProductCategory;
GO

INSERT INTO Production.LockedCategories
VALUES(5, 'Category canceled');
GO

INSERT INTO Production.ProductSubcategory (ProductCategoryID, Name)
VALUES (5, 'classic-bike-1');
GO
SELECT * FROM Production.ProductSubcategory WHERE ProductCategoryID=5;
GO

CREATE OR ALTER TRIGGER Production.tr_ProductSubcategory_limit ON Production.ProductSubcategory 
FOR INSERT, UPDATE
AS
BEGIN
	SET NOCOUNT ON;

	IF EXISTS(
		SELECT * FROM inserted i
		JOIN Production.LockedCategories lc ON i.ProductCategoryID = lc.LockedCategoryID)
	BEGIN;
		THROW 50001, 'Category not allowed', 0;
		-- PRINT 'Category not allowed';
		-- ROLLBACK;
	END
	
END;
GO

INSERT INTO Production.ProductSubcategory (ProductCategoryID, Name)
VALUES (5, 'classic-road-bike2');
GO

SELECT * FROM Production.ProductSubcategory WHERE ProductCategoryID=5;

DELETE FROM Production.ProductSubcategory WHERE ProductCategoryID=5;
DELETE FROM Production.ProductCategory WHERE ProductCategoryID=5;
DELETE FROM Production.ProductSubcategory WHERE ProductCategoryID=6;
DELETE FROM Production.ProductCategory WHERE ProductCategoryID=6;