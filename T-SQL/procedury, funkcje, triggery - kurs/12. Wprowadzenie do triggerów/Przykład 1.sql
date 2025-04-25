SELECT TOP (1000) [ShipMethodID]
      ,[Name]
      ,[ShipBase]
      ,[ShipRate]
      ,[rowguid]
      ,[ModifiedDate]
  FROM [AdventureWorks].[Purchasing].[ShipMethod]
GO

CREATE TRIGGER Purchasing.tr_ShipMethod_log_insert ON Purchasing.ShipMethod
FOR INSERT
AS
BEGIN
	PRINT 'New row(s) inserted';
END
GO

INSERT INTO Purchasing.ShipMethod (Name, ShipBase, ShipRate)
VALUES('Post', 10, 1);

INSERT INTO Purchasing.ShipMethod (Name, ShipBase, ShipRate)
VALUES('Frog Delivery', 9, 0.99), ('Eagle Station', 8, 0.88);

DELETE FROM Purchasing.ShipMethod WHERE Name = 'Post';
GO

CREATE TRIGGER Purchasing.tr_ShipMethod_log_delete ON Purchasing.ShipMethod
FOR DELETE
AS
BEGIN
	PRINT 'Row(s) deleted';
END
GO

DELETE FROM Purchasing.ShipMethod WHERE Name = 'Frog Delivery';

UPDATE Purchasing.ShipMethod SET Name = 'Falcoln Station' WHERE Name = 'Eagle Station';
GO

CREATE TRIGGER Purchasing.tr_ShipMethod_log_update ON Purchasing.ShipMethod
FOR UPDATE
AS
BEGIN
	PRINT 'Row(s) updated'
END
GO

UPDATE Purchasing.ShipMethod SET Name = 'Eagle Station' WHERE Name = 'Falcoln Station';