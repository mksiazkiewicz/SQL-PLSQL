/*1. Kontynuujemy zadanie �ledzenia �stan�w magazynowych� w tabeli produkt�w. Obowi�zuj� 
wszystkie do tej pory przyj�te za�o�enia. Tym razem: 
a. Ilekro� zostanie usuni�ty rekord zakupu dla danego produktu (RecordType = �B�), trzeba 
b�dzie zaktualizowa� rekord produktu odejmuj�c od aktualnej liczby produkt�w 
(TotalAmount) liczb� kupionych produkt�w (Amount) 
b. Ilekro� zostanie usuni�ty rekord sprzeda�y dla danego produktu (RecordType=�S�), trzeba 
b�dzie zaktualizowa� rekord produktu dodaj�c do aktualnej liczby produkt�w 
(TotalAmount)  liczb� sprzedanych produkt�w (Amount). 
2. Napisz trigger, kt�ry w przypadku usuni�cia rekordu typu B z tabeli dbo.Transactions zmniejszy 
stan produkt�w w tabeli dbo.Products, a w przypadku usuni�cia rekordu typu S, zwi�kszy stan 
produkt�w.  
3. Przetestuj dzia�anie triggera usuwaj�c kilka rekord�w*/

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