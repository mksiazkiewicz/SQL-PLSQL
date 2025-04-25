ALTER TABLE Purchasing.ShipMethod_log 
ADD Action CHAR(1) DEFAULT 'I';
GO

CREATE OR ALTER TRIGGER Purchasing.tr_ShipMethod_log_insert ON Purchasing.ShipMethod FOR INSERT
AS
	SET NOCOUNT ON
	INSERT INTO Purchasing.ShipMethod_log(ShipMethodID, Name, ShipBase, ShipRate, ModUser, ModDateTime, Action)
	SELECT
		i.ShipMethodID, i.Name, i.ShipBase, i.ShipRate, SUSER_SNAME(), GetDate(), 'I'
	FROM inserted AS i;
GO

CREATE OR ALTER TRIGGER Purchasing.tr_ShipMethod_log_delete ON Purchasing.ShipMethod FOR DELETE
AS
	SET NOCOUNT ON
	INSERT INTO Purchasing.ShipMethod_log(ShipMethodID, Name, ShipBase, ShipRate, ModUser, ModDateTime, Action)
	SELECT
		d.ShipMethodID, d.Name, d.ShipBase, d.ShipRate, SUSER_SNAME(), GetDate(), 'D'
	FROM deleted AS d;
GO

SELECT * FROM Purchasing.ShipMethod;

DELETE FROM Purchasing.ShipMethod WHERE Name = 'Eagle Station';

SELECT * FROM Purchasing.ShipMethod_log;

UPDATE Purchasing.ShipMethod_log SET Action = 'I' WHERE Action IS NULL;

DELETE FROM Purchasing.ShipMethod WHERE Name = 'Frog Delivery' OR Name = 'Pigeon';

SELECT * FROM Purchasing.ShipMethod_log;