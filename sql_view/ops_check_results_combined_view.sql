USE [AdventureWorks2019]
GO

/****** Object:  View [dbo].[v_ops_check_results_combined]    Script Date: 1/16/2024 9:03:38 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




ALTER VIEW [dbo].[v_ops_check_results_combined]
AS

--checks eligible for rerun 
select a.ops_check_id, a.rundate, a.ops_check_count as count, b.ops_check_count as rerun_count, a.flag_status , b.flag_status as rerun_status  
from [ops_check_results] a
inner join [ops_check_results_rerun] b
on a.ops_check_id = b.ops_check_id
and CONVERT(CHAR(8),a.rundate,112) = CONVERT(CHAR(8),b.rundate,112)
where a.rundate >= CONVERT (VARCHAR(8),GETDATE() -6,112) and a.rundate < CONVERT (VARCHAR(8),GETDATE()+1,112)

union

--checks that didn't flag
select ops_check_id, rundate, ops_check_count as count, ops_check_count as rerun_count, flag_status, '0' as rerun  
from [ops_check_results]
where flag_status = 0
and rundate >= CONVERT (VARCHAR(8),GETDATE() -6,112) and rundate < CONVERT (VARCHAR(8),GETDATE()+1,112)

union

--checks with erroneous script(or sp)
select ops_check_id, rundate, ops_check_count as count, ops_check_count as rerun_count, flag_status, '1' as rerun  
from [ops_check_results]
where ops_check_count is NULL
and rundate >= CONVERT (VARCHAR(8),GETDATE() -6,112) and rundate < CONVERT (VARCHAR(8),GETDATE()+1,112)

GO