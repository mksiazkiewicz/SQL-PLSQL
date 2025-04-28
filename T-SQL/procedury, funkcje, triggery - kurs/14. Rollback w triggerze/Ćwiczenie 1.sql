/*1. W naszej firmie zaobserwowano spadek sprzeda¿y w œrody. Firma postanawia³a wiec 
uruchomiæ promocje w œrody. Polegaj¹ one na tym, ¿e klienci mog¹ uzyskaæ rabat 10% 
w³aœnie w œrody. Niestety system pozwala³ handlowcom udzielaæ tego rabatu te¿ w inne dni 
tygodnia. Dlatego zdecydowano siê na utworzenie tabeli, w której wprowadzona jest nazwa 
dnia tygodnia i maksymalny rabat, jaki mo¿na tego dnia przydzieliæ. Uruchom ten kod, aby 
utworzyæ i wype³niæ tabelê. Kod tworzy te¿ fikcyjn¹ tabelê dla zamówieñ 
CREATE TABLE dbo.Promotions 
( DayOfWeek NVARCHAR(20) PRIMARY KEY, 
  MaxPromotionPercent DECIMAL(3,1)); 
GO 
 -- 2222-01-02 is Wednesday 
INSERT INTO dbo.Promotions (DayOfWeek, MaxPromotionPercent) VALUES 
(DATENAME(WEEKDAY,'2222-01-02'),10); 
GO 
 
CREATE TABLE dbo.Invoices 
( Id INT IDENTITY NOT NULL, 
  ClientID INT, 
  InvoiceDate DATE, 
  PromotionPercent DECIMAL(3,1)); 
GO 
2. Napisz trigger dla tabeli zamówieñ, który uniemo¿liwi wstawienie rekordu z dat¹ 
przypadaj¹c¹ w dniu tygodnia opisanym w tabeli Promotions, jeœli chocia¿ jeden ze 
wstawianych rekordów ma wartoœæ promocji (PromotionPercent) wiêkszy ni¿ zdefiniowany 
w tabeli Promotions maksymalny rabat (MaxPromotionPercent) 
3. Jeœli twój trigger dzia³a tylko dla INSERT, to pomyœl, jak mo¿na by obejœæ jego dzia³anie, jeœli 
nasz handlowiec jest hakerem samoukiem… W takim przypadku rozbuduj swojego triggera 
równie¿ o kontrolê operacji UPDATE.
*/

--1
CREATE TABLE dbo.Promotions 
( DayOfWeek NVARCHAR(20) PRIMARY KEY, 
  MaxPromotionPercent DECIMAL(3,1)); 
GO 
 -- 2222-01-02 is Wednesday 
INSERT INTO dbo.Promotions (DayOfWeek, MaxPromotionPercent) VALUES 
(DATENAME(WEEKDAY,'2222-01-02'),10); 
GO 
 
CREATE TABLE dbo.Invoices 
( Id INT IDENTITY NOT NULL, 
  ClientID INT, 
  InvoiceDate DATE, 
  PromotionPercent DECIMAL(3,1)); 
GO 

--2
CREATE OR ALTER TRIGGER dbo.tr_Invoices_insert_update ON dbo.Invoices FOR INSERT, UPDATE
AS
BEGIN
	SET NOCOUNT ON;
	
	IF EXISTS (
		SELECT * FROM inserted i 
		JOIN dbo.Promotions p ON (DATENAME(WEEKDAY,i.InvoiceDate)) = p.DayOfWeek
		WHERE i.PromotionPercent > p.MaxPromotionPercent)
	BEGIN;
		THROW 50001, 'Promotion cannot be higher than promotion rate for selected days', 0;
	END;
END;
GO

-- œroda, %rabatu wiêkszy niz w tabeli
INSERT INTO dbo.Invoices(ClientID,InvoiceDate,PromotionPercent)
VALUES (3,'2025-04-30',20);

--œroda, %rabatu mniejszy niz w tabeli
INSERT INTO dbo.Invoices(ClientID,InvoiceDate,PromotionPercent)
VALUES (3,'2025-04-30',5);

--poniedzia³ek
INSERT INTO dbo.Invoices(ClientID,InvoiceDate,PromotionPercent)
VALUES (3,'2025-04-28',20);

SELECT * FROM dbo.Invoices
