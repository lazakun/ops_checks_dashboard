USE [msdb]
GO

/****** Object:  Job [ops_check_job]    Script Date: 1/16/2024 11:25:47 AM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 1/16/2024 11:25:47 AM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'ops_check_job', 
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
/****** Object:  Step [run]    Script Date: 1/16/2024 11:25:47 AM ******/
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
		@command=N'IF OBJECT_ID(''tempdb..#tmpResults'') IS NOT NULL
		DROP TABLE #tmpResults;

	CREATE TABLE #tmpResults(
		ops_check_id int,
		ops_check_count	float,
		rundate			datetime
	  );

	IF OBJECT_ID(''tempdb..#tmpErrors'') IS NOT NULL
		DROP TABLE #tmpErrors;

	CREATE TABLE #tmpErrors(
		ops_check_id int
		, ErrorNumber varchar(100)
		, ErrorMessage varchar(255)
	  );

--fetch and execute checks within the time frame
DECLARE  @ops_check_script_sp NVARCHAR(MAX) 
declare @ops_check_id int
DECLARE cursor_product CURSOR
FOR  
select ops_check_id, ops_check_script_sp
from   [AdventureWorks2019].[dbo].ops_check
where  ops_check_status = 1
and    ops_check_time <= DATEPART(HOUR,GETDATE())
and ops_check_id not in (select ops_check_id from ops_check_results where rundate >= CAST(GETDATE() as DATE)
and rundate < CAST(DATEADD(d,1,GETDATE()) as DATE))
  OPEN cursor_product;
FETCH NEXT FROM 
  cursor_product INTO 
  @ops_check_id,
  @ops_check_script_sp
  WHILE @@FETCH_STATUS = 0    
  BEGIN 
BEGIN TRY
INSERT INTO #tmpResults (ops_check_id,ops_check_count,rundate)
execute sp_executesql @ops_check_script_sp

END TRY

BEGIN CATCH

	INSERT INTO #tmpErrors (ops_check_id,ErrorNumber,ErrorMessage)
	select @ops_check_id, CAST(ERROR_NUMBER() AS VARCHAR(100)),SUBSTRING(ERROR_MESSAGE(),1,255);

END CATCH


	FETCH NEXT FROM cursor_product INTO
	@ops_check_id,@ops_check_script_sp
	END;
	CLOSE cursor_product;
DEALLOCATE cursor_product; 

--caters for ops check sp(or script) with errors
insert into [AdventureWorks2019].[dbo].[ops_check_results]
select ops_check_id, NULL, 1, getdate()  from #tmpErrors

--check for flag status and insert into the main_run table
insert into [AdventureWorks2019].[dbo].[ops_check_results]
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
on a.ops_check_id = b.ops_check_id

--insert checks that flag into the rerun table
insert into [AdventureWorks2019].[dbo].[ops_check_results_rerun]
select * from [ops_check_results]
where rundate >= CAST(GETDATE() as DATE)
and flag_status = 1
and ops_check_id not in (
select ops_check_id from [AdventureWorks2019].[dbo].ops_check_results_rerun where rundate >= CAST(GETDATE() as DATE)
and rundate < CAST(DATEADD(d,1,GETDATE()) as DATE))', 
		@database_name=N'AdventureWorks2019', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'10am', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20240116, 
		@active_end_date=99991231, 
		@active_start_time=100000, 
		@active_end_time=235959, 
		@schedule_uid=N'8e56e330-1e2d-45bd-87d4-6703bf42d004'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'11am', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20240116, 
		@active_end_date=99991231, 
		@active_start_time=110000, 
		@active_end_time=235959, 
		@schedule_uid=N'd4a7bb0b-4efb-432e-b029-40b3abc70718'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'7am', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20240116, 
		@active_end_date=99991231, 
		@active_start_time=70000, 
		@active_end_time=235959, 
		@schedule_uid=N'3372901a-2f12-4f5c-a61c-32ada162e77d'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'8am', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20240116, 
		@active_end_date=99991231, 
		@active_start_time=80000, 
		@active_end_time=235959, 
		@schedule_uid=N'f15d73a2-1cab-4257-820d-1c43db6d8d14'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'9am', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20240116, 
		@active_end_date=99991231, 
		@active_start_time=90000, 
		@active_end_time=235959, 
		@schedule_uid=N'c92c5564-6db1-4638-bceb-c2b8eab24b2b'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO


