/* 10 ************************************************/
Create Database DBStats
GO


USE [DBStats];

CREATE TABLE [dbo].[DayCheckList](
	[DayID] [int] IDENTITY(1,1) NOT NULL,
	[EventStatus] [varchar](50) NOT NULL,
	[EventDate] [datetime] NULL,
	[EVENT] [varchar](2000) NOT NULL,
 CONSTRAINT [PK_DayCheckList] PRIMARY KEY CLUSTERED 
(
	[DayID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


CREATE TABLE [dbo].[MonthCheckList](
	[MonthID] [int] IDENTITY(1,1) NOT NULL,
	[EventStatus] [varchar](50) NOT NULL,
	[EventDate] [datetime] NULL,
	[EVENT] [varchar](2000) NOT NULL,
 CONSTRAINT [PK_MonthCheckList] PRIMARY KEY CLUSTERED 
(
	[MonthID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/* 20 ************************************************/
CREATE PROCEDURE GetDriveSpaceFree
AS
DECLARE @driveSpace TABLE (drive CHAR(2), MBFree int)
INSERT INTO @driveSpace
EXEC sp_executesql N'xp_fixeddrives'

INSERT INTO dbstats..daychecklist
	SELECT 'Drive Space', GETDATE(), 'Free space on ' + drive + ' is ' + CONVERT (VARCHAR(20), MBFree/1024) + ' Gigs' 
		FROM @driveSpace

/* 25 ************************************************/

-- Using For Each DB to capture File Growth

CREATE TABLE [dbo].[File_growth](
	[FileGrowthID] [int] IDENTITY(1,1) NOT NULL,
	[Physical_Name] [varchar](200) NULL,
	[Size_in_MB] [int] NULL,
	[Size_in_GB] [int] NULL,
	[Reading_date] [datetime] NULL,
 CONSTRAINT [PK_File_growth] PRIMARY KEY CLUSTERED 
(
	[FileGrowthID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[File_growth] ADD  DEFAULT (getdate()) FOR [Reading_date]
GO


CREATE Procedure [dbo].[GetFile_growth]
AS
declare @RETURN_VALUE int
declare @command1 nvarchar(2000)
set @command1 = 'Select 
	Physical_name,
	size_in_MB = (size * 8 / 1024),
	size_in_GB = (size * 8 / 1024 / 1024)
	from sys.database_files'

select @command1
Insert Into File_growth (Physical_Name, Size_in_MB,Size_in_GB)
	exec @RETURN_VALUE = sp_MSforeachdb @command1 = @command1
	
GO

/* 30 *************************************************************/


-- Using an Extended Stored and Procedure and CTE to capture the Error Log

-- Why did I decide to not use the same format as the other procs with tables?


Create Procedure GetFilteredErrorLog
AS
	DECLARE @Errorlog TABLE (LogDate datetime, ProcessorInfo VARCHAR (100),ErrorMSG VARCHAR(2000))
INSERT INTO @Errorlog

EXEC sp_executesql N'xp_readerrorlog'

Delete 
	FROM @Errorlog 
	WHERE ErrorMSG LIKE '%Log was backed up%'

Delete 
	FROM @Errorlog 
	WHERE ErrorMSG LIKE '%Setting database option COMPATIBILITY_LEVEL%'

Delete 
	FROM @Errorlog 
	WHERE ErrorMSG LIKE '%were backed up%'
	
Delete 
	FROM @Errorlog 
	WHERE ErrorMSG LIKE '%DBCC TRACEON%'
	
	
Delete 
	FROM @Errorlog 
	WHERE ErrorMSG LIKE '%without errors%'
	
	
INSERT INTO dbstats..daychecklist
	SELECT 'Error Log',Logdate,SUBSTRING(ErrorMSG, 1, 2000) 
	FROM @Errorlog 
	WHERE LogDate > DATEADD(dd, -1, GETDATE()) 
	
INSERT INTO dbstats..daychecklist
	SELECT 'Restart',Logdate,ErrorMSG 
	FROM @Errorlog 
	WHERE ErrorMSG LIKE '%Starting up database%'
	AND LogDate > DATEADD(dd, -7, GETDATE()) 



/* 50 **********************************************************************/
CREATE TABLE [dbo].[IndexFrag](
	[IndexFrag] [int] IDENTITY(1,1) NOT NULL,
	[DatabaseName] [varchar](100) NOT NULL,
	[TableName] [varchar](100) NOT NULL,
	[IndexName] [varchar](200) NULL,
	[PercentFragmented] [int] NOT NULL,
 CONSTRAINT [PK_IndexFrag] PRIMARY KEY CLUSTERED 
(
	[IndexFrag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

Create Procedure GetIndexFragPercent
AS
Insert Into IndexFrag
	SELECT 
		db_name(), 
		Object_Name(ps.object_id), 
		i.name as Index_Name,  
		round(avg_fragmentation_in_percent, 0)
	FROM sys.dm_db_index_physical_stats(db_id(), null, null, NULL, NULL) ps
		Join sys.indexes i on ps.Object_ID = i.object_ID and ps.index_id = i.index_id

GO

/* 60 *****************************************************/



CREATE TABLE [dbo].[ProcdureExecutionTimes](
	[ProdExecTimeID] [int] IDENTITY(1,1) NOT NULL,
	[dbname] [varchar](200) NOT NULL,
	[spname] [varchar](2000) NULL,
	[ExeCount] [bigint] NULL,
	[ExePerSec] [bigint] NULL,
	[AvgWorkerTime] [bigint] NULL,
	[TotalWorkerTime] [bigint] NULL,
	[AvgElapsedTime] [bigint] NULL,
	[MaxLogicalReads] [bigint] NULL,
	[MaxLogicalWrites] [bigint] NULL,
	[TotalPhysicalReads] [bigint] NULL,
	[DateRecorded] [datetime] NULL,
 CONSTRAINT [PK_ProcdureExecutionTimes] PRIMARY KEY CLUSTERED 
(
	[ProdExecTimeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


-- try nullif

CREATE PROCEDURE [dbo].[GetProcExectionTimes]
AS

		INSERT INTO DBSTats..ProcdureExecutionTimes 
	(dbname,SPname, ExeCount, ExePerSec, AvgWorkerTime, TotalWorkerTime, AvgElapsedTime, MaxLogicalReads, MaxLogicalWrites, TotalPhysicalReads, DateRecorded)
		SELECT 
                     DB_Name() AS dbname,
                     OBJECT_SCHEMA_NAME(qt.objectid, qt.dbid) + '.' + object_name(qt.objectid, qt.dbid) AS spname,
                     qs.execution_count AS 'Execution Count',  
                     isnull(qs.execution_count,.0001)/Isnull(DATEDIFF(Second, qs.creation_time, GetDate()),.0001) AS 'Calls/Second',
                     isnull(qs.total_worker_time,1)/isnull(qs.execution_count,1) AS 'AvgWorkerTime',
                     qs.total_worker_time AS 'TotalWorkerTime',
                     isnull(qs.total_elapsed_time,1)/isnull(qs.execution_count,1) AS 'AvgElapsedTime',
                     qs.max_logical_reads, 
                     qs.max_logical_writes, 
                     qs.total_physical_reads,
                     GETDATE() AS RecordedDate
              FROM sys.dm_exec_query_stats AS qs
                     CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS qt
              ORDER BY qs.execution_count DESC


-- Be aware of what this does....


DBCC FreeProcCache


GO

