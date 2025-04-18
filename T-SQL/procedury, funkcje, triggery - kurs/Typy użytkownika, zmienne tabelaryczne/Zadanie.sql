/*
1. Utwórz typ OrderNote odpowiadaj¹cy typowy NVARCHAR(MAX) NOT NULL. 
2. Utwórz tabelê pamiêciow¹ o strukturze: 
a. ClientId – liczba ca³kowita 
b. OrderDate – DATETIME2 
c. OrderNote typu OrderNote 
3. Do tej zmiennej wstaw rekordy: 
a. Klient 20, data dzisiejsza, komentarz ‘black and white please’ 
b. Klient 21, data dzisiejsza, komentarz pusty ‘  ‘ 
4. Zmodyfikuj w tej tabeli rekord dla ClientId 20 zmieniaj¹c komentarz na ‘only black and white 
please’ 
5. Dodaj do tabeli jeszcze jeden rekord 
a. Klient 22, data dzisiejsza, komentarz ‘Leave the package in the bakery shop. I’’m on a 
trip’  
6. Wyœwietl rekordy z tabeli */

--1
CREATE TYPE OrderNote FROM  NVARCHAR(MAX);
--2
DECLARE @table 
AS TABLE
(ClientId INT,
OrderDate DATETIME2,
OrderNote OrderNote
);
--3
INSERT INTO @table (ClientId,OrderDate,OrderNote)
VALUES (20, SYSDATETIME(), 'black and white please'), (21, SYSDATETIME(), '');
--4
UPDATE @table
SET OrderNote = 'only black and white please' WHERE ClientId= 20;
--5
INSERT INTO @table (ClientId,OrderDate,OrderNote)
VALUES (22, SYSDATETIME(), 'Leave the package in the bakery shop. I’m on a trip');
--6
SELECT * FROM @table
