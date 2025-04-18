-- tabela s³u¿¹ca do aktualizacji nag³ówka 
zamówienia:
/*CREATE TABLE Sales.ShopOrder 
( 
Id INT IDENTITY PRIMARY KEY, 
ClientId INT NOT NULL REFERENCES Person.Person(BusinessEntityId), 
OrderDate DATETIME2 DEFAULT SYSDATETIME(), 
OrderNote NVARCHAR(MAX) NULL 
) 
GO */

/*Procedura powinna: 
e. Sprawdziæ czy @Id jest NULL-em 
f. Jeœli tak, to do tabeli Sales.ShopOrder nale¿y wstawiæ rekord inicjuj¹c jego wartoœci w 
oparciu o parametry 
g. Jeœli nie, to nale¿y zaktualizowaæ rekord identyfikowany przez Id równy @Id i przypisaæ 
wartoœci w rekordzie w oparciu o wartoœci przekazanych parametrów.
*/

CREATE or ALTER PROCEDURE Sales.usp_UpdateShopOrder 
@Id INT NULL OUTPUT, 
@ClientID INT NULL, 
@OrderDate DATETIME2 NULL, 
@OrderNote NVARCHAR(MAX) NULL 
as
BEGIN
	if @id is null 
		begin
		insert into Sales.ShopOrder (ClientId,OrderDate,OrderNote)
		values (@ClientID, @OrderDate, @OrderNote)

		SET @id = SCOPE_IDENTITY();

		end
	else 
		begin
		if exists (select * from Sales.ShopOrder where id= @id)
			begin
			update Sales.ShopOrder
			set ClientId = @ClientID, OrderDate = @OrderDate, OrderNote = @OrderNote
			where   id = @Id
			end
		else
		
		THROW 50001, 'You cannot modify non-existing order!',1;
		END
END
go


------------------------------------
DECLARE @date DATETIME2; 
SET @date = SYSDATETIME(); 
DECLARE @id int = null;

BEGIN TRY
EXEC Sales.usp_UpdateShopOrder   
@ClientId = 16,  
@OrderDate = @date,  
@OrderNote = 'Please pack in a cardboard box',
@id = @id OUTPUT; 

	SELECT @id as 'New id'

END TRY
BEGIN CATCH
PRINT 'Operation failed with error: ' + ERROR_MESSAGE();
END CATCH

select * from Sales.ShopOrder 
GO

--------------------------------------- 
 
 
DECLARE @date DATETIME2; 
SET @date = SYSDATETIME(); 
BEGIN TRY
	EXEC Sales.usp_UpdateShopOrder @Id = 87897891,  
                  @ClientId = 16,  
                  @OrderDate = @date,  
                  @OrderNote = 'Please pack in a cardboard box'; 
END TRY
BEGIN CATCH
PRINT 'Operation failed with error: ' + ERROR_MESSAGE();
END CATCH
GO 
 
 -----------
 
DECLARE @date DATETIME2; 
SET @date = SYSDATETIME(); 
EXEC @RC = Sales.usp_UpdateShopOrder @Id = 1000,  
                  @ClientId = 16,  
                  @OrderDate = @date,  
                  @OrderNote = 'Please pack in a cardboard box'; 
SELECT @RC; 
GO