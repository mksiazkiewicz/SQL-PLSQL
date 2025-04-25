/*4. Kontynuujemy zadanie œledzenia „stanów magazynowych” w tabeli produktów: Przyjête do tej 
pory za³o¿enia s¹ nadal w mocy. Tym razem: 
a. Ilekroæ zostanie zmodyfikowany rekord zakupu (RecordType=’B’) dla danego produktu, 
trzeba bêdzie zaktualizowaæ rekord produktu odejmuj¹c od aktualnej liczby produktów 
(TotalAmount) liczbê kupionych produktów (Amount) z tabeli deleted i dodaæ liczbê 
kupionych produktów z tabeli inserted 
b. Ilekroæ zostanie zmodyfikowany rekord sprzeda¿y dla danego produktu 
(RecordType=’S’), trzeba bêdzie zaktualizowaæ rekord produktu dodaj¹c do aktualnej 
liczby produktów (TotalAmount) liczbê sprzedanych produktów (Amount) z tabeli 
deleted i odj¹æ liczbê sprzedanych produktów z tabeli inserted. 
5. Napisz trigger, który w przypadku modyfikacji rekordu w tabeli dbo.Transactions odpowiednio 
zaktualizuje stan magazynowy w tabeli dbo.Products.  
6. Przetestuj dzia³anie triggera modyfikuj¹c kilka rekordów.*/

CREATE OR ALTER TRIGGER tr_update_transactions ON dbo.Transactions FOR UPDATE
AS
BEGIN
	SET NOCOUNT ON;
	--2
	IF EXISTS (SELECT COUNT(*) FROM inserted GROUP BY ProductId HAVING COUNT(*) > 1) 
	THROW 50001, 'ONE TRANSACTION CAN UPDATE A PRODUCT ONLY ONCE',1;

	-- stara wersja rekordów
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

	-- nowa wersja rekordów
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
