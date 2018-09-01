CREATE PROCEDURE [dbo].[SS_Users_Session_Validate]
	@Login [varchar](200),
	@SessionId [varchar](100)
--WITH ENCRYPTION
AS
BEGIN
		/*------------------------------------------------------------------------------
		-- declaracion de variables
		--------------------------------------------------------------------------------*/
	Declare  @IsErrorTecnichal int,@sError varchar(max), @UserId int, @Name varchar(200),@Profile varchar(200)
	Declare  @MinuteSession int,@SessionId_aux [varchar](100),@Email varchar(250),@Section varchar(25)
	Execute C_Parameter_Get @CodeParameter= 'ERROR_TECNICHAL', @Value= @IsErrorTecnichal OUTPUT
	Execute C_Parameter_Get @CodeParameter= 'TIME_SESSION_APP', @Value= @MinuteSession OUTPUT
	BEGIN TRY
		Set @SessionId_aux=@SessionId
		if Not Exists(Select *
						From AppUsers
						Inner Join AppSessions On AppSessions.UserId=AppUsers.UserId
						Where AppUsers.Login=@Login and AppSessions.SessionId=@SessionId)
		Begin
			Raiserror('Los valores para renovación de Token invalidos %s %s',16,1,@Login,@SessionId)
			return
		End
		Select @UserId= AppUsers.UserId,@Name=Name,@Profile=Appprofiles.Profile,@Email=Email,@Section=AppProfiles.Section
		From AppUsers
				Inner JOIN Appprofiles On Appprofiles.ProfileId=appusers.ProfileId
				Inner Join AppSessions On AppSessions.UserId=AppUsers.UserId
		Where AppUsers.Login=@Login and AppSessions.SessionId=@SessionId

		Set @SessionId=newid()
		Execute SS_Users_Session_Save	@SessionId=@SessionId,@UserId =@UserId

		Delete From AppSessions Where SessionId=@SessionId_aux
		Select @UserId as UserId, @Name as Name,@Profile as Profile,@SessionId as SessionId,@Login as Login, @MinuteSession as Expiration,@Section as Section

		Exec [App_History_Timeline_Save]
					@SessionId =@SessionId,
					@UpdatedId =@UserId,
					@Type='USERS',
					@TimeLine='RESET_Token',
					@Comments='Reiniciar Token del usuario'

		Exec BG_EmailQueue_Save
			 @ToEmail =@Email
			,@EmailTo ='RESET_Token'
			,@UpdatedId =@UserId 
	END TRY
	Begin Catch
    	    --Getting the error description
			Set @sError  = ERROR_MESSAGE()
			if @IsErrorTecnichal=1
			Begin
			Set @sError  =  ERROR_PROCEDURE() + 
					';  ' + convert(varchar,ERROR_LINE()) + 
					'; ' + ERROR_MESSAGE()
			End 
    	    -- save the error in a Log file
    	    RaisError(@sError,16,1) 
    	    Return  
    End Catch
END