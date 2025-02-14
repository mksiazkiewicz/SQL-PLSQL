declare @date DATE = GETDATE()

if DATEPART(weekday,@date) = 1 or DATEPART(weekday,@date) = 7
	begin
	print 'It is weekend!!'
	end
else
	begin
	print 'It is a working day... :( '
	end