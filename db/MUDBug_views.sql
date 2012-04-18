use DBStats
GO

create view MUDBUGDriveSpace
as
select * from [dbo].[DayCheckList] where EventStatus = 'Drive Space'

GO

create view MUDBugErrorLog
as
select * from [dbo].[DayCheckList] where EventStatus = 'Error Log'

GO

create view MUDBugRestart
as
select * from [dbo].[DayCheckList] where EventStatus = 'Restart'
