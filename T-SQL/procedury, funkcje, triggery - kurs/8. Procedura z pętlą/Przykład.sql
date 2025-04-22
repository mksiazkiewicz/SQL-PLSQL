CREATE OR ALTER PROCEDURE dbo.uspGenerateCalendar
	@Year INT,
	@Month INT
AS
BEGIN
	 SET NOCOUNT ON;

	 DECLARE @StartDate DATE = DATEFROMPARTS(@Year, @Month, 1);
	 DECLARE @EndDate DATE = EOMONTH(@StartDate);
	 DECLARE @DaysInMonth INT = DAY(@EndDate);
		DECLARE @Day INT = 0;
		DECLARE @Calendar AS TABLE (Day DATE, DayOfWeek NVARCHAR(30));

		WHILE @Day < @DaysInMonth
		BEGIN
			INSERT INTO @Calendar(Day)
			VALUES (DATEADD(DAY,@Day,@StartDate));
			SET @Day +=1;
		END;

		UPDATE @Calendar SET DayOfWeek = DATEPART(WEEKDAY, Day);

		SELECT * FROM @Calendar;
END
GO

EXEC dbo.uspGenerateCalendar @Year = 2025, @Month = 6;

CREATE TABLE #dates (day DATE, day_of_week NVARCHAR(30));

INSERT INTO #dates
EXEC dbo.uspGenerateCalendar @Year = 2025, @Month = 6;

SELECT * FROM #dates;