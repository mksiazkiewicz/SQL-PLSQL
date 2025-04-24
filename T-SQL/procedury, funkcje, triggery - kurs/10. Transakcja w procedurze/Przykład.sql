CREATE TABLE dbo.Products
(
 ProductId INT IDENTITY PRIMARY KEY,
 ProductName NVARCHAR(50),
 Quantity INT
);

CREATE TABLE dbo.DamagedProducts
(
 DamagedId INT IDENTITY PRIMARY KEY,
 ProductId INT,
 Quantity INT
);
GO

CREATE PROCEDURE dbo.RegisterDamage @ProductId INT, @Quantity INT
AS
BEGIN
    SET XACT_ABORT ON; --w przypadku napotkania b³êdu, transakcja ma zostaæ 
zerwana
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;
			UPDATE dbo.Products
			SET Quantity = Quantity - @Quantity
			WHERE ProductId = @ProductId;

			INSERT INTO dbo.DamagedProducts(ProductId, Quantity)
			VALUES (@ProductId, @Quantity);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 --oznacza liczbê w danej chwili otwartych zagnie¿d¿onych transakcji
            ROLLBACK TRANSACTION;

        THROW 50020, 'Error when registering damaged product', 1
    END CATCH;
END;

INSERT INTO dbo.Products(ProductName, Quantity)
VALUES
('Calculator', 100), ('Mouse', 44), ('Disk', 2);

SELECT * FROM dbo.Products;
SELECT * FROM dbo.DamagedProducts;

EXECUTE dbo.RegisterDamage @ProductId=2, @Quantity=4;

SELECT * FROM dbo.Products;
SELECT * FROM dbo.DamagedProducts;