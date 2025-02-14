USE tempdb
GO

-- Kopia tabeli
SELECT *
INTO SalesOrderHeader
FROM Sales.SalesOrderHeader
GO

-- Stworzenie procedury
CREATE PROCEDURE UpdateOrderStatus 
@OrderId INT
AS 
BEGIN
UPDATE SalesOrderHeader
SET Status = 1 
WHERE SalesOrderID = @OrderId
END
GO

-- Wywo³anie procedury dla przyk³adowego Id
EXEC UpdateOrderStatus '64551'
GO

-- Sprawdzenie wyniku
SELECT * FROM SalesOrderHeader
WHERE SalesOrderID = 64551
GO