CREATE Procedure [dbo].[App_Home_DashBoard_List]
--With Encryption
As
	Declare @in_user_count int,@in_user_active int,@in_email_ok int, @in_email_process int,@in_session_count int
	Declare @in_user_inactive int,@in_time_session int,@in_session_active int, @in_session_expire int
	Execute C_Parameter_Get @CodeParameter= 'TIME_SESSION_APP', @Value= @in_time_session OUTPUT
	/*------------------------------------------------------------------------------
	-- getting xml main list only range: records_[begin,end], setting record status.
	------------------------------------------------------------------------------*/
	Select @in_user_active=count(*) From [AppUsers] Where IsActive=1
	Select @in_user_inactive=count(*) From [AppUsers] Where IsActive=0
	Select @in_user_count=count(*) From [AppUsers]
	Select @in_email_ok=count(*) From [AppSendEmail] Where StatusSend='OK'
	Select @in_email_process=count(*) From [AppSendEmail] Where StatusSend='PROCESS'
	Select @in_session_active=count(*) From AppSessions where DATEDIFF(day,Updated,getdate())<= day(8500)
	Select @in_session_expire=count(*) From AppSessions where DATEDIFF(day,Updated,getdate())> day(8500)
	Select @in_session_count=count(*) From AppSessions  
	Declare @in_hourmax int,@in_hour120 int,@in_hour96 int,@in_hour72 int,@in_hour48 int,@in_hour24 int
	Select @in_hourmax= Count(*)  from AppMessageLog Where DATEDIFF(HOUR,Creation,getdate()) >120
	Select @in_hour120= Count(*)  from AppMessageLog Where DATEDIFF(HOUR,Creation,getdate()) between 97 and 120
	Select @in_hour96= Count(*)  from AppMessageLog Where DATEDIFF(HOUR,Creation,getdate()) between 73 and 96
	Select @in_hour72= Count(*)  from AppMessageLog Where DATEDIFF(HOUR,Creation,getdate()) between 49 and 72
	Select @in_hour48= Count(*)  from AppMessageLog Where DATEDIFF(HOUR,Creation,getdate()) between 25 and 48
	Select @in_hour24= Count(*)  from AppMessageLog Where DATEDIFF(HOUR,Creation,getdate()) between 1 and 24 
	------------------------------------------------------------------------------
	-- Declaring variables
	------------------------------------------------------------------------------
	SELECT @in_user_active as in_user_active,
			@in_user_count as in_user_count,
			@in_email_ok as in_email_ok,
			@in_email_process as in_email_process,
			@in_user_inactive as in_user_inactive,
			@in_session_active as in_session_active,
			@in_session_expire as in_session_expire,
			@in_session_count as in_session_count,
			@in_hourmax as in_hourmax,
			@in_hour120 as in_hour120,
			@in_hour96 as in_hour96,
			@in_hour72 as in_hour72,
			@in_hour48 as in_hour48,
			@in_hour24 as in_hour24