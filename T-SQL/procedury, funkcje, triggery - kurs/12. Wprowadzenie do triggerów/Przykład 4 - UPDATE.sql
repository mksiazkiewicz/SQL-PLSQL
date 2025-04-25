CREATE OR ALTER TRIGGER Purchasing.tr_ShipMethod_log_update ON Purchasing.ShipMethod FOR UPDATE
AS
BEGIN
	SET NOCOUNT ON

	INSERT INTO Purchasing.ShipMethod_log(ShipMethodID, Name, ShipBase, ShipRate, ModUser, ModDateTime, Action)
	SELECT
		d.ShipMethodID, d.Name, d.ShipBase, d.ShipRate, SUSER_SNAME(), GetDate(), 'B'
	FROM deleted AS d;

	INSERT INTO Purchasing.ShipMethod_log(ShipMethodID, Name, ShipBase, ShipRate, ModUser, ModDateTime, Action)
	SELECT
		i.ShipMethodID, i.Name, i.ShipBase, i.ShipRate, SUSER_SNAME(), GetDate(), 'A'
	FROM inserted AS i;
END
GO

SELECT * FROM Purchasing.ShipMethod;

UPDATE Purchasing.ShipMethod 
SET ShipBase = ShipBase * 2
WHERE Name LIKE 'OVER%';

SELECT * FROM Purchasing.ShipMethod_log;