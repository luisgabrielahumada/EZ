CREATE PROCEDURE [dbo].[SS_Users_Login_Validate]
	@Login [varchar](200),
	@Password [varchar](100)
--WITH ENCRYPTION
AS
BEGIN
		/*------------------------------------------------------------------------------
		-- declaracion de variables
		--------------------------------------------------------------------------------*/
	Declare  @IsErrorTecnichal int,@sError varchar(max), @UserId int, @Name varchar(200),@Profile varchar(200),@SessionId varchar(4000)
	Declare  @MinuteSession int,@Email varchar(250),@ProfileId int,@Section Varchar(25)
	Execute C_Parameter_Get @CodeParameter= 'ERROR_TECNICHAL', @Value= @IsErrorTecnichal OUTPUT
	Execute C_Parameter_Get @CodeParameter= 'TIME_SESSION_APP', @Value= @MinuteSession OUTPUT
	BEGIN TRY
		if Not Exists(Select *
						From AppUsers
						Where AppUsers.Login=@Login and AppUsers.Password=@Password)
		Begin
			Raiserror('Login or password is not valid..',16,1)
			return
		End
		Select @UserId= UserId,@Name=Name,@Profile=Appprofiles.Profile,@Email=Email,
				@ProfileId=AppUsers.ProfileId,@Section=AppProfiles.Section
		From AppUsers
				Inner JOIN AppProfiles On AppProfiles.ProfileId=AppUsers.ProfileId
		Where AppUsers.Login=@Login and AppUsers.Password=@Password

		Set @SessionId=newid()
		Execute SS_Users_Session_Save	@SessionId=@SessionId,@UserId =@UserId

		Exec [App_History_Timeline_Save]
					@SessionId =@SessionId,
					@UpdatedId =@UserId,
					@Type='USERS',
					@TimeLine='LOGIN',
					@Comments='Login del Usuario'

		--Select * from  AppProfilesMenus
		--Select * From AppAccessUsers
		Select @UserId as UserId, @Name as Name,@Profile as Profile,@SessionId as SessionId,@Login as Login, @MinuteSession as Expiration,@ProfileId as ProfileId,@Section as Section

	Exec BG_EmailQueue_Save
			 @ToEmail =@Email
			,@EmailTo ='LOGIN'
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