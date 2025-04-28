	pc.ProductCategoryID, pc.Name AS CatName,
	ps.ProductSubcategoryID, ps.Name AS SubName
FROM Production.ProductCategory pc
JOIN Production.ProductSubcategory ps 
	ON pc.ProductCategoryID = ps.ProductCategoryID;
GO

CREATE VIEW Production.ProdCatSub
AS
SELECT 
	pc.ProductCategoryID, pc.Name AS CatName,
	ps.ProductSubcategoryID, ps.Name AS SubName
FROM Production.ProductCategory pc
JOIN Production.ProductSubcategory ps 
	ON pc.ProductCategoryID = ps.ProductCategoryID;
GO

SELECT * FROM Production.ProdCatSub WHERE CatName LIKE 'Cl%';
GO

INSERT INTO Production.ProdCatSub (CatName, SubName)
VALUES ('Classics', 'Equipment');
GO

CREATE OR ALTER TRIGGER Production.tr_prodcatsub_insert ON Production.ProdCatSub INSTEAD OF INSERT
AS
BEGIN
	SET NOCOUNT ON;

	-- Insert into Categories
	INSERT INTO Production.ProductCategory(Name)
	SELECT i.CatName FROM inserted i
	WHERE NOT EXISTS (SELECT * FROM Production.ProductCategory WHERE Name = i.CatName);

	-- Insert into SubCategory
	INSERT INTO Production.ProductSubcategory(Name, ProductCategoryID)
		SELECT
			i.SubName, pc.ProductCategoryID
		FROM inserted i
		JOIN Production.ProductCategory pc ON pc.Name = i.CatName
		WHERE NOT EXISTS (SELECT * FROM Production.ProductSubcategory WHERE Name = i.SubName);

END;
GO

INSERT INTO Production.ProdCatSub (CatName, SubName)
VALUES ('Classics', 'Equipment');
GO

SELECT * FROM Production.ProdCatSub WHERE CatName LIKE 'Cl%';
GO

INSERT INTO Production.ProdCatSub (CatName, SubName)
VALUES ('Classics', 'Equipment'),
       ('Classics', 'Tools'),
	   ('Classics', 'Accessories'),
	   ('Club', 'Branding'),
	   ('Club', 'Documents');
GO