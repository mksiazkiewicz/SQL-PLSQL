/*1. Kontynuujemy zadanie œledzenia „stanów magazynowych” w tabeli produktów. Obowi¹zuj¹ 
wszystkie do tej pory przyjête za³o¿enia. Tym razem: 
a. Ilekroæ zostanie usuniêty rekord zakupu dla danego produktu (RecordType = ‘B’), trzeba 
bêdzie zaktualizowaæ rekord produktu odejmuj¹c od aktualnej liczby produktów 
(TotalAmount) liczbê kupionych produktów (Amount) 
b. Ilekroæ zostanie usuniêty rekord sprzeda¿y dla danego produktu (RecordType=’S’), trzeba 
bêdzie zaktualizowaæ rekord produktu dodaj¹c do aktualnej liczby produktów 
(TotalAmount)  liczbê sprzedanych produktów (Amount). 
2. Napisz trigger, który w przypadku usuniêcia rekordu typu B z tabeli dbo.Transactions zmniejszy 
stan produktów w tabeli dbo.Products, a w przypadku usuniêcia rekordu typu S, zwiêkszy stan 
produktów.  
3. Przetestuj dzia³anie triggera usuwaj¹c kilka rekordów*/

CREATE OR ALTER TRIGGER tr_delete_transactions ON dbo.Transactions FOR DELETE
AS
BEGIN
	SET NOCOUNT ON;
	--2
	IF EXISTS (SELECT COUNT(*) FROM deleted GROUP BY ProductId HAVING COUNT(*) > 1) 
	THROW 50001, 'ONE TRANSACTION CAN UPDATE A PRODUCT ONLY ONCE',1;

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
END;
GO

SELECT * FROM dbo.Transactions; 
SELECT * FROM dbo.Products; 

DELETE FROM dbo.Transactions WHERE ID IN (1,2,4)

SELECT * FROM dbo.Products; 