/*CREATE TABLE HumanResources.InOut
( Id INT IDENTITY PRIMARY KEY,
  BusinessEntityID INT  NOT NULL
    CONSTRAINT FK_InOut_Person_BusinessEntityID FOREIGN KEY REFERENCES Person.BusinessEntity(BusinessEntityID),
  RegIn DATETIME NULL,
  RegOut DATETIME NULL
);
GO

ALTER TABLE HumanResources.InOut ADD RegInDate AS CAST(RegIn AS DATE) PERSISTED;
GO

CREATE UNIQUE INDEX IX_HumanResources_InOut_BusinessEntityID_RegInDate 
ON HumanResources.InOut(BusinessEntityID, RegInDate);
GO*/

CREATE OR ALTER PROCEDURE HumanResources.RegisterTime
	@BusinessEntityId INT,
	@RegIn DATETIME,
	@RegOut DATETIME
AS
BEGIN
	if @RegIn is null
	begin;
	THROW 50001, 'Entry date cannot be empty',1;
	end

	if @RegIn is not null and @RegIn > @RegOut
	begin;
	THROW 50002, 'Entry date cannot be later than exit time',1;
	end 

	IF @RegOut is null and CAST(@RegOut as DATE) <> CAST(@Regin as DATE)
	BEGIN;
	THROW 50003, 'Exit date and entry date must be the same day',1;
	END

	IF NOT EXISTS (SELECT * FROM HumanResources.InOut 
	where BusinessEntityID=@BusinessEntityId AND RegInDate=CAST(@RegIn AS DATE))
	BEGIN
	insert into HumanResources.InOut  (BusinessEntityId, RegIn, RegOut)
	values (@BusinessEntityId,@RegIn,@RegOut)
	END
	else
	begin
	update HumanResources.InOut  set
	RegIn = @RegIn, 
	RegOut = @RegOut
	where BusinessEntityId = @BusinessEntityId and RegInDate=CAST(@RegIn AS DATE)
	end
return 0
END; 
GO


BEGIN TRY
	EXEC HumanResources.RegisterTime 
		@BusinessEntityID = 13,
		@RegIn =  '2033-03-03 17:05',
		@RegOut = '2033-03-03 16:05';
END TRY
BEGIN CATCH
PRINT 'Operation failed with error: ' + ERROR_MESSAGE();
END CATCH

SELECT * FROM HumanResources.InOut;