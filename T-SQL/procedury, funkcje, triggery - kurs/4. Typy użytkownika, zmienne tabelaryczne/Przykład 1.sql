DECLARE @myId CHAR(11) = '012345678790';
SELECT @myId as 'My ID';
GO

CREATE TYPE IDGOV FROM CHAR(11) NOT NULL;
GO

DECLARE @myId IDGOV = '042101876543';
SELECT @myId;
GO

CREATE SCHEMA personal;
GO

CREATE TABLE personal.person
(
 id INT IDENTITY PRIMARY KEY,
 first_name NVARCHAR(50),
 last_name NVARCHAR(50),
 idgov IDGOV
);
GO

INSERT INTO personal.person
VALUES('John', 'Walker', '01234567890');
GO

SELECT * FROM personal.person;
GO

INSERT INTO personal.person
VALUES('John', 'Walker', NULL);
GO

DROP TYPE IF EXISTS IDGOV;

DROP TABLE IF EXISTS personal.person;

DROP TYPE IF EXISTS IDGOV;

DROP SCHEMA IF EXISTS personal;

DECLARE @SelectedEmployees
AS TABLE
( BusinessEntityID INT,
  RegIn [datetime] NULL,
  RegOut [datetime] NULL
);

INSERT INTO @SelectedEmployees(BusinessEntityId, RegIn, RegOut)
VALUES
  (1, '2033-03-03 7:40', NULL), (2, '2033-03-03 7:50', '2033-03-03 17:04'), 
  (3, '2033-03-03 8:01', '2033-03-03 15:03'), (4, '2033-03-03 8:11', '2033-03-03 15:03');

SELECT * FROM @SelectedEmployees
GO