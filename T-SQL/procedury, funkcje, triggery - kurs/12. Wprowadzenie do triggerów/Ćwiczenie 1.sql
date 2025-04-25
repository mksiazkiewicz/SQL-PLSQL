/*
1. Utw�rz nast�puj�c� tabel�: 
CREATE TABLE dbo.app_log 
([ID] INT IDENTITY PRIMARY KEY, 
[WHO] SYSNAME DEFAULT SUSER_SNAME(), 
[WHEN] DATETIME2 DEFAULT SYSDATETIME(), 
[TABLE] SYSNAME, 
[OPERATION] VARCHAR(10)); 
2. Napisz triggery obs�uguj�ce: 
a. Insert na tabeli Sales.ShopOrder. Trigger powinien zapisa� w tabeli dbo.app_log, 
informacj� o tym, �e na tabeli ShopOrder uruchomiono polecenie INSERT. 
b. Update na tabeli Sales.ShopOrder. Trigger powinien zapisa� w tabeli dbo.app_log, 
informacj� o tym, �e na tabeli ShopOrder uruchomiono polecenie UDPATE. 
c. Delete na tabeli Sales.ShopOrder. Trigger powinien zapisa� w tabeli dbo.app_log, 
informacj� o tym, �e na tabeli ShopOrder uruchomiono polecenie DELETE. 
3. Przetestuj dzia�anie trigger�w wstawiaj�c, modyfikuj�c i usuwaj�c rekord(y) 
4. Usu� triggery */

--1
CREATE TABLE dbo.app_log 
([ID] INT IDENTITY PRIMARY KEY, 
[WHO] SYSNAME DEFAULT SUSER_SNAME(), 
[WHEN] DATETIME2 DEFAULT SYSDATETIME(), 
[TABLE] SYSNAME, 
[OPERATION] VARCHAR(10));
GO

--2
CREATE OR ALTER TRIGGER Sales.tr_shoporder_insert ON Sales.ShopOrder 
FOR INSERT
AS
BEGIN
	INSERT INTO dbo.app_log ([TABLE], [OPERATION]) VALUES ('ShopOrder', 'INSERT');
END;
GO

CREATE OR ALTER TRIGGER Sales.tr_shoporder_update ON Sales.ShopOrder 
FOR UPDATE
AS
BEGIN
	INSERT INTO dbo.app_log([TABLE], [OPERATION]) VALUES ('ShopOrder', 'UPDATE'); 
END;
GO

CREATE OR ALTER TRIGGER Sales.tr_shoporder_delete ON Sales.ShopOrder 
FOR DELETE
AS
BEGIN
	INSERT INTO dbo.app_log([TABLE], [OPERATION]) VALUES ('ShopOrder', 'DELETE'); 
END;
GO

INSERT INTO Sales.ShopOrder(ClientId, OrderDate, OrderNote) VALUES (20, SYSDATETIME(), 'Test insert'); 
UPDATE Sales.ShopOrder SET OrderDate=SYSDATETIME() WHERE Id = 1005;
DELETE FROM Sales.ShopOrder  WHERE Id = 1005;

SELECT * FROM dbo.app_log;


 DROP TRIGGER IF EXISTS Sales.tr_shoporder_insert; 
 DROP TRIGGER IF EXISTS Sales.tr_shoporder_update; 
 DROP TRIGGER IF EXISTS Sales.tr_shoporder_delete; 