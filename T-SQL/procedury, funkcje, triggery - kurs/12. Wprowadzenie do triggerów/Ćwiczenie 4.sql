/*4. Kontynuujemy zadanie �ledzenia �stan�w magazynowych� w tabeli produkt�w: Przyj�te do tej 
pory za�o�enia s� nadal w mocy. Tym razem: 
a. Ilekro� zostanie zmodyfikowany rekord zakupu (RecordType=�B�) dla danego produktu, 
trzeba b�dzie zaktualizowa� rekord produktu odejmuj�c od aktualnej liczby produkt�w 
(TotalAmount) liczb� kupionych produkt�w (Amount) z tabeli deleted i doda� liczb� 
kupionych produkt�w z tabeli inserted 
b. Ilekro� zostanie zmodyfikowany rekord sprzeda�y dla danego produktu 
(RecordType=�S�), trzeba b�dzie zaktualizowa� rekord produktu dodaj�c do aktualnej 
liczby produkt�w (TotalAmount) liczb� sprzedanych produkt�w (Amount) z tabeli 
deleted i odj�� liczb� sprzedanych produkt�w z tabeli inserted. 
5. Napisz trigger, kt�ry w przypadku modyfikacji rekordu w tabeli dbo.Transactions odpowiednio 
zaktualizuje stan magazynowy w tabeli dbo.Products.  
6. Przetestuj dzia�anie triggera modyfikuj�c kilka rekord�w.*/

CREATE OR ALTER TRIGGER tr_update_transactions ON dbo.Transactions FOR UPDATE
AS
BEGIN
	SET NOCOUNT ON;
	--2
	IF EXISTS (SELECT COUNT(*) FROM inserted GROUP BY ProductId HAVING COUNT(*) > 1) 
	THROW 50001, 'ONE TRANSACTION CAN UPDATE A PRODUCT ONLY ONCE',1;

	-- stara wersja rekord�w
	-- dla transakcji typu 'B'
	UPDATE dbo.Products
	SET TotalAmount = TotalAmount - d.Amount
	FROM dbo.Products p 
	JOIN deleted d ON p.Id = d.ProductId
	WHERE d.RecordType = 'B';

	-- dla transakcji typu 'S'
	UPDATE dbo.Products
	SET TotalAmount = TotalAmount + d.Amount
	FROM dbo.Products p 
	JOIN deleted d ON p.Id=d.ProductId
	WHERE d.RecordType = 'S';

	-- nowa wersja rekord�w
	-- dla transakcji typu 'B'
		UPDATE dbo.Products
	SET TotalAmount = TotalAmount + i.Amount
	FROM dbo.Products p 
	JOIN inserted i ON p.Id = i.ProductId
	WHERE i.RecordType = 'B';

	-- dla transakcji typu 'S'
	UPDATE dbo.Products
	SET TotalAmount = TotalAmount - i.Amount
	FROM dbo.Products p 
	JOIN inserted i ON p.Id=i.ProductId
	WHERE i.RecordType = 'S';
END;
GO

SELECT * FROM dbo.Transactions; 
SELECT * FROM dbo.Products; 

UPDATE dbo.Transactions
SET Amount -=  100 WHERE Id IN (3,5);

SELECT * FROM dbo.Transactions; 
SELECT * FROM dbo.Products; 
