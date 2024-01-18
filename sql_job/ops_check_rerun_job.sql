USE [msdb]
GO

/****** Object:  Job [ops_check_rerun_job]    Script Date: 1/16/2024 11:27:00 AM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 1/16/2024 11:27:00 AM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'ops_check_rerun_job', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [run]    Script Date: 1/16/2024 11:27:00 AM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'run', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'	IF OBJECT_ID(''tempdb..#tmpResults'') IS NOT NULL
		DROP TABLE #tmpResults;

	CREATE TABLE #tmpResults(
		ops_check_id int,
		ops_check_count	float,
		rundate			datetime
	  );

IF OBJECT_ID(''tempdb..#tmpRerun'') IS NOT NULL
		DROP TABLE #tmpRerun;

CREATE TABLE #tmpRerun(
		ops_check_id int,
		ops_check_script_sp NVARCHAR(MAX)
	  );

--fetch all flagged checks from the main run
insert into #tmpRerun
select ops_check_id, ops_check_script_sp
from   ops_check
where  ops_check_status = 1
and ops_check_id  in (select ops_check_id from [AdventureWorks2019].[dbo].ops_check_results where rundate >= CAST(GETDATE() as DATE)
and rundate < CAST(DATEADD(d,1,GETDATE()) as DATE)
and flag_status =1
and ops_check_count is not NULL)

--remove checks that are no longer flagging after rerun
delete from #tmpRerun
where ops_check_id in (select ops_check_id from [AdventureWorks2019].[dbo].ops_check_results_rerun where flag_status = 0
and rundate >= CAST(GETDATE() as DATE))

--fetch and execute flagged checks
DECLARE  @ops_check_script_sp NVARCHAR(MAX) 
declare @ops_check_id int
DECLARE cursor_product CURSOR
FOR  
select ops_check_id, ops_check_script_sp
from #tmpRerun
  OPEN cursor_product;
FETCH NEXT FROM 
  cursor_product INTO 
  @ops_check_id,
  @ops_check_script_sp
  WHILE @@FETCH_STATUS = 0    
  BEGIN 
INSERT INTO #tmpResults (ops_check_id,ops_check_count,rundate)
execute sp_executesql @ops_check_script_sp

	FETCH NEXT FROM cursor_product INTO
	@ops_check_id,@ops_check_script_sp
	END;
	CLOSE cursor_product;
DEALLOCATE cursor_product; 

--delete initial rerun checks
delete from [AdventureWorks2019].[dbo].[ops_check_results_rerun]
where ops_check_id in (select ops_check_id from #tmpResults)
and rundate >= CAST(GETDATE() as DATE)
and rundate < CAST(DATEADD(d,1,GETDATE()) as DATE)

--check for flag status and insert into the rerun table
insert into [AdventureWorks2019].[dbo].[ops_check_results_rerun]
select a.ops_check_id
,ops_check_count
,case
when ops_check_count >= expected_min and ops_check_count <= expected_max then 0
--when ops_check_count between expected_min and expected_max then 0
else 1
end as flag
,rundate
from #tmpResults a
inner join [AdventureWorks2019].[dbo].ops_check b
on a.ops_check_id = b.ops_check_id', 
		@database_name=N'AdventureWorks2019', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'30mins', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=4, 
		@freq_subday_interval=30, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20240116, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'60ce9240-1771-4abd-9e30-0c7be9586ae1'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO


