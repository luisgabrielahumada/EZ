CREATE PROCEDURE [dbo].[SS_Users_Change_Password]
	@SessionId [varchar](200),
	@Password [varchar](100),
	@UpdatedId int=0,
	@Comments varchar(max)
--WITH ENCRYPTION
AS
BEGIN
		/*------------------------------------------------------------------------------
		-- declaracion de variables
		--------------------------------------------------------------------------------*/
	Declare  @IsErrorTecnichal int,@sError varchar(max),@UserId int,@Email varchar(20)
	begin try
		begin  Transaction
		Update AppUsers
			Set Password=@Password
		From  AppSessions 
			Inner Join AppUsers On  AppUsers.UserId=AppSessions.UserId
		Where AppSessions.SessionId=@SessionId
		Commit Transaction

		Select @UserId=AppUsers.UserId,@Email=Email
		From AppUsers
		Inner Join AppSessions On AppSessions.SessionId=@SessionId
		Where AppUsers.UserId=AppSessions.UserId
		Exec [App_History_Timeline_Save]
					@SessionId =@SessionId,
					@UpdatedId =@UserId,
					@Type='USERS',
					@TimeLine='CHANGE_PASSWORD',
					@Comments=@Comments

		Exec BG_EmailQueue_Save
				 @ToEmail =@Email
				,@EmailTo ='CHANGE_PASSWORD'
				,@UpdatedId =@UserId 
	end try
	Begin Catch
    	    -- there was an error
    	    If XACT_STATE() =-1
    	    Begin
    	    	    Rollback WORK
    	    End
    	    If @@trancount >0
    	    Begin
    	    	    Rollback WORK
    	    End
    	    If XACT_STATE() = 1
    	    Begin
    	    	    Commit WORK
    	    End
    	    --Getting the error description
    	    Set @sError  =   ERROR_MESSAGE()
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