/*
1. W zwi¹zku z kolejn¹ ods³on¹ ustawy o ochronie danych osobowych, nale¿y przygotowaæ 
procedurê, która pozwoli programiœcie zmieniæ ustawienia dotycz¹ce udzia³u w promocjach dla 
klientów zarejestrowanych w tabeli Person.Person. 
a. Procedura Person.UpdatePersonEmail ma przyjmowaæ 3 argumenty: 
i. @BusinessIdentityId – INT 
ii. @Promotion – BIT, domyœlnie 0 
iii. @Email – NVARCHAR(50), domyœlnie NULL 
b. W procedurze nale¿y ustawiæ parametry pozwalaj¹ce ukryæ informacje o rekordach 
modyfikowanych przez procedurê i ustawiæ parametr przerywaj¹cy procedurê w 
przypadku napotkania b³êdów. 
c. Nale¿y skontrolowaæ, czy dochodzi do sytuacji, w której ktoœ rejestruje udzia³ w promocji 
(parametr @Promotion jest równy 1), ale nie poda³ adresu email (@Email jest NULLem). 
Jeœli by siê tak zdarzy³o nale¿y zg³osiæ odpowiedni b³¹d 
d. W transakcji zabezpieczonej przed b³êdem nale¿y: 
- W tabeli Person.Person ustawiæ pole EmailPromotion zgodnie z wartoœci¹ 
parametru @Promotion dla rekordu identyfikowanego przez @BusinessEntityID  
- Jeœli @Promotion jest równe 1, to nale¿y jeszcze wymieniæ wszystkie adresy 
email na ten nowy z @Email 
1. Usuñ wszystkie rekordy z Person.EmailAddres zarejestrowane dla 
zadanego @BusinessEntityId 
2. Dodaj nowy rekord dla @BusinessEntityID i @Email 
- Jeœli nie by³o b³êdów zatwierdŸ transakcjê 
- Jeœli by³y b³êdy wycofaj transakcjê i zg³oœ b³¹d
2. Zobacz aktualne ustawienia dotycz¹ce EmailPromotion i adresów email dla rekordu 3 i 4
3. Uruchom procedurê wskazuj¹c, ¿e osoba nr 3 nie chce ju¿ uczestniczyæ w promocjach. Po 
uruchomieniu procedury oczekiwany wynik jest taki, ¿e EmailPromotion bêdzie równe 0, a 
adresy email pozostan¹ bez zmian. 
4. Uruchom procedurê wskazuj¹c, ¿e osoba nr 4 chce uczestniczyæ w promocji, ale nie podawaj 
adresu email. Spodziewany efekt jest taki, ¿e procedura zakoñczy siê b³êdem 
5. Uruchom procedurê wskazuj¹c, ¿e osoba nr 4 chce uczestniczyæ w promocji i podaj adres email. 
Spodziewany efekt jest taki, ¿e zmieni siê wartoœæ w EmailPromotion na 1, stare adresy email 
zostan¹ usuniête, a zostanie zarejestrowany nowy adres.
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