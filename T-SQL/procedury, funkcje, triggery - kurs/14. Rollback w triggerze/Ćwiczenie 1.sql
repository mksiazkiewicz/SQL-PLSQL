/*1. W naszej firmie zaobserwowano spadek sprzeda�y w �rody. Firma postanawia�a wiec 
uruchomi� promocje w �rody. Polegaj� one na tym, �e klienci mog� uzyska� rabat 10% 
w�a�nie w �rody. Niestety system pozwala� handlowcom udziela� tego rabatu te� w inne dni 
tygodnia. Dlatego zdecydowano si� na utworzenie tabeli, w kt�rej wprowadzona jest nazwa 
dnia tygodnia i maksymalny rabat, jaki mo�na tego dnia przydzieli�. Uruchom ten kod, aby 
utworzy� i wype�ni� tabel�. Kod tworzy te� fikcyjn� tabel� dla zam�wie� 
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
2. Napisz trigger dla tabeli zam�wie�, kt�ry uniemo�liwi wstawienie rekordu z dat� 
przypadaj�c� w dniu tygodnia opisanym w tabeli Promotions, je�li chocia� jeden ze 
wstawianych rekord�w ma warto�� promocji (PromotionPercent) wi�kszy ni� zdefiniowany 
w tabeli Promotions maksymalny rabat (MaxPromotionPercent) 
3. Je�li tw�j trigger dzia�a tylko dla INSERT, to pomy�l, jak mo�na by obej�� jego dzia�anie, je�li 
nasz handlowiec jest hakerem samoukiem� W takim przypadku rozbuduj swojego triggera 
r�wnie� o kontrol� operacji UPDATE.
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

-- �roda, %rabatu wi�kszy niz w tabeli
INSERT INTO dbo.Invoices(ClientID,InvoiceDate,PromotionPercent)
VALUES (3,'2025-04-30',20);

--�roda, %rabatu mniejszy niz w tabeli
INSERT INTO dbo.Invoices(ClientID,InvoiceDate,PromotionPercent)
VALUES (3,'2025-04-30',5);

--poniedzia�ek
INSERT INTO dbo.Invoices(ClientID,InvoiceDate,PromotionPercent)
VALUES (3,'2025-04-28',20);

SELECT * FROM dbo.Invoices
