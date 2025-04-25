CREATE TABLE Purchasing.ShipMethod_log
(
	ID INT IDENTITY PRIMARY KEY,
	ShipMethodID INT,
	Name NVARCHAR(50),
	ShipBase money,
	ShipRate money,
	ModUser SYSNAME,
	ModDateTime DATETIME
);
GO

CREATE OR ALTER TRIGGER Purchasing.tr_ShipMethod_log_insert ON Purchasing.ShipMethod FOR INSERT
AS
	SET NOCOUNT ON --Trigger powinien ukrywaæ swoj¹ dzia³alnoœæ przed u¿ytkownikami (SET NOCOUNT ON) 
	INSERT INTO Purchasing.ShipMethod_log(ShipMethodID, Name, ShipBase, ShipRate, ModUser, ModDateTime)
	SELECT
		i.ShipMethodID, i.Name, i.ShipBase, i.ShipRate, SUSER_SNAME(), GetDate()
	FROM inserted AS i;
GO

INSERT INTO Purchasing.ShipMethod (Name, ShipBase, ShipRate)
VALUES('Post', 10, 1);

SELECT * FROM Purchasing.ShipMethod_log;

INSERT INTO Purchasing.ShipMethod (Name, ShipBase, ShipRate)
VALUES('Frog Delivery', 9, 0.99), ('Pigeon', 8, 0.88);

SELECT * FROM Purchasing.ShipMethod_log;