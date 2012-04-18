USE [DBStats]
GO


CREATE PROCEDURE [dbo].[DayCheck]
AS


------------------------ Maintenance Work---------------------------------------

INSERT INTO MonthCheckList
	SELECT        EventStatus, EventDate, [EVENT]
FROM            DayCheckList

IF @@error = 0
	BEGIN
		Delete dbstats..DayCheckList
	END

--------------------------- Disk Space------------------------------------------

EXECUTE GetDriveSpaceFree
EXECUTE GetFile_growth
		 
--------------------------Read Error Log---------------------------------------

EXECUTE GetFilteredErrorLog

--------------------------Get Report Stats -----------------------------------

-- EXECUTE GetReportStats

--------------------------Get Index Frag -----------------------------------
-- Add Filtering for tables that still look ok

EXECUTE GetIndexFragPercent

--------------------------Get Procedure Execution -----------------------------------
-- Talk about DBCC FreeProcCache

--EXECUTE GetProcExectionTimes

--------------------------Get Processing UTI -----------------------------------
-- Add Filtering for tables that still look ok
-- Make sure the server is enabled for CLR
-- Make sure Assembly is in place

--EXECUTE GetProcUTI

GO


