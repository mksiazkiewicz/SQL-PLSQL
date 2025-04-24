/*
1. W zwi�zku z kolejn� ods�on� ustawy o ochronie danych osobowych, nale�y przygotowa� 
procedur�, kt�ra pozwoli programi�cie zmieni� ustawienia dotycz�ce udzia�u w promocjach dla 
klient�w zarejestrowanych w tabeli Person.Person. 
a. Procedura Person.UpdatePersonEmail ma przyjmowa� 3 argumenty: 
i. @BusinessIdentityId � INT 
ii. @Promotion � BIT, domy�lnie 0 
iii. @Email � NVARCHAR(50), domy�lnie NULL 
b. W procedurze nale�y ustawi� parametry pozwalaj�ce ukry� informacje o rekordach 
modyfikowanych przez procedur� i ustawi� parametr przerywaj�cy procedur� w 
przypadku napotkania b��d�w. 
c. Nale�y skontrolowa�, czy dochodzi do sytuacji, w kt�rej kto� rejestruje udzia� w promocji 
(parametr @Promotion jest r�wny 1), ale nie poda� adresu email (@Email jest NULLem). 
Je�li by si� tak zdarzy�o nale�y zg�osi� odpowiedni b��d 
d. W transakcji zabezpieczonej przed b��dem nale�y: 
- W tabeli Person.Person ustawi� pole EmailPromotion zgodnie z warto�ci� 
parametru @Promotion dla rekordu identyfikowanego przez @BusinessEntityID  
- Je�li @Promotion jest r�wne 1, to nale�y jeszcze wymieni� wszystkie adresy 
email na ten nowy z @Email 
1. Usu� wszystkie rekordy z Person.EmailAddres zarejestrowane dla 
zadanego @BusinessEntityId 
2. Dodaj nowy rekord dla @BusinessEntityID i @Email 
- Je�li nie by�o b��d�w zatwierd� transakcj� 
- Je�li by�y b��dy wycofaj transakcj� i zg�o� b��d
2. Zobacz aktualne ustawienia dotycz�ce EmailPromotion i adres�w email dla rekordu 3 i 4
3. Uruchom procedur� wskazuj�c, �e osoba nr 3 nie chce ju� uczestniczy� w promocjach. Po 
uruchomieniu procedury oczekiwany wynik jest taki, �e EmailPromotion b�dzie r�wne 0, a 
adresy email pozostan� bez zmian. 
4. Uruchom procedur� wskazuj�c, �e osoba nr 4 chce uczestniczy� w promocji, ale nie podawaj 
adresu email. Spodziewany efekt jest taki, �e procedura zako�czy si� b��dem 
5. Uruchom procedur� wskazuj�c, �e osoba nr 4 chce uczestniczy� w promocji i podaj adres email. 
Spodziewany efekt jest taki, �e zmieni si� warto�� w EmailPromotion na 1, stare adresy email 
zostan� usuni�te, a zostanie zarejestrowany nowy adres.
*/

CREATE OR ALTER PROCEDURE Person.UpdatePersonEmail 
@BusinessIdentityId INT,
@Promotion BIT = 0,
@Email NVARCHAR(50) = NULL
AS 
BEGIN
	SET XACT_ABORT ON;
	SET NOCOUNT ON;

	IF (@Promotion = 1 AND @Email IS NULL)
	BEGIN;
	THROW 50010, 'While enabling promotion, you must send a email address', 1;
	END

	BEGIN TRY
		BEGIN TRANSACTION;
			UPDATE Person.Person 
			SET EmailPromotion = @Promotion WHERE BusinessEntityID = @BusinessIdentityId;

			IF @Promotion = 1 
			BEGIN
			DELETE Person.EmailAddress WHERE BusinessEntityID = @BusinessIdentityId;
			INSERT INTO Person.EmailAddress (BusinessEntityID, EmailAddress)
			VALUES (@BusinessIdentityId, @Email);
			END
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		THROW 50020, 'Error with updating records', 1
	END CATCH;
END;
GO

SELECT p.BusinessEntityID, p.EmailPromotion, e.EmailAddress   
FROM Person.Person AS p  
LEFT JOIN Person.EmailAddress AS e ON e.BusinessEntityID=p.BusinessEntityID 
WHERE p.BusinessEntityID IN (3,4); 

--3
EXEC Person.UpdatePersonEmail @BusinessIDentityId = 3, @Promotion = 0;
--4
EXEC Person.UpdatePersonEmail @BusinessIDentityId = 4, @Promotion = 1;
--5
EXEC Person.UpdatePersonEmail @BusinessIDentityId = 4, @Promotion = 1, @Email = 'mail@mail.com';