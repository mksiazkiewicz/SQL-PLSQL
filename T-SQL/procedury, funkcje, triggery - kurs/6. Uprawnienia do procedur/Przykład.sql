CREATE SCHEMA photo;
GO

CREATE TABLE photo.pictures
(name NVARCHAR(MAX));
INSERT INTO photo.pictures VALUES ('Elephant'), ('Giraffe');
GO

CREATE SCHEMA reporters;
GO

CREATE PROC reporters.get_pictures
AS
  SELECT name FROM photo.pictures;
GO

CREATE USER reporter_user WITHOUT LOGIN;
CREATE ROLE reporter_role;
ALTER ROLE reporter_role ADD MEMBER reporter_user;
GRANT EXECUTE ON SCHEMA::reporters TO reporter_role;
GO

EXECUTE AS USER='reporter_user';
SELECT USER_NAME();
EXEC reporters.get_pictures;
REVERT
SELECT USER_NAME();
GO

EXECUTE AS USER='reporter_user';
SELECT USER_NAME();
SELECT name FROM photo.pictures;
REVERT
SELECT USER_NAME();
GO

SELECT s.name, p.name
FROM sys.schemas s
JOIN sys.database_principals p ON s.principal_id=p.principal_id
WHERE s.name IN ('photo','reporters');
GO

CREATE USER photo_boss WITHOUT LOGIN;
ALTER AUTHORIZATION ON SCHEMA::photo TO photo_boss;
GO

SELECT s.name, p.name
FROM sys.schemas s
JOIN sys.database_principals p ON s.principal_id=p.principal_id
WHERE s.name IN ('photo','reporters');
GO

EXECUTE AS USER='reporter_user';
SELECT USER_NAME();
EXEC reporters.get_pictures;
REVERT
SELECT USER_NAME();
GO

ALTER PROC reporters.get_pictures
WITH EXECUTE AS 'photo_boss'
AS 
  SELECT name FROM photo.pictures;
GO

EXECUTE AS USER='reporter_user';
SELECT USER_NAME();
EXEC reporters.get_pictures;
REVERT
SELECT USER_NAME();
GO

ALTER PROC reporters.get_pictures
WITH EXECUTE AS 'photo_boss'
AS 
  PRINT 'Procedure executed as ' + USER_NAME();
  SELECT name FROM photo.pictures;
GO


EXECUTE AS USER='reporter_user';
SELECT USER_NAME();
EXEC reporters.get_pictures;
REVERT
SELECT USER_NAME();
GO

ALTER PROC reporters.get_pictures
WITH EXECUTE AS CALLER
AS 
  PRINT 'Procedure executed as ' + USER_NAME();
  SELECT name FROM photo.pictures;
GO

EXECUTE AS USER='reporter_user';
SELECT USER_NAME();
EXEC reporters.get_pictures;
REVERT
SELECT USER_NAME();
GO