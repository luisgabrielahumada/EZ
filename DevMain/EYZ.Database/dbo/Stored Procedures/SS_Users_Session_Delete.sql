CREATE PROCEDURE [dbo].[SS_Users_Session_Delete]
	@SessionId [varchar](400)
--WITH ENCRYPTION
AS
BEGIN
	/*------------------------------------------------------------------------------
		Declares variables No se ha podido actualizar la información.  Intente de nuevo.
	------------------------------------------------------------------------------*/
	Declare @sError varchar(max) ,@IsErrorTecnichal int,@UserId int
	Execute C_Parameter_Get @CodeParameter= 'ERROR_TECNICHAL', @Value= @IsErrorTecnichal OUTPUT
	/*------------------------------------------------------------------------------
		get current variable stream
	------------------------------------------------------------------------------*/
	Begin Try
	Select @UserId=AppUsers.UserId
		From AppUsers
		Inner Join AppSessions On AppSessions.SessionId=@SessionId
		Where AppUsers.UserId=AppSessions.UserId

	Exec [App_History_Timeline_Save]
					@SessionId =@SessionId,
					@UpdatedId =@UserId,
					@Type='USERS',
					@TimeLine='LOGOUT',
					@Comments='Cerrando session'
	Begin Transaction
		Delete From AppSessions
		Where AppSessions.SessionId=@SessionId
	Commit Transaction

	
	------------------------------------------------------------------------------
	-- send back answer
	------------------------------------------------------------------------------
	End Try
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
		Set @sError  =  ERROR_MESSAGE()
		if @IsErrorTecnichal=1
		Begin
			Set @sError  =  ERROR_PROCEDURE() + 
					';  ' + convert(varchar,ERROR_LINE()) + 
					'; ' + ERROR_MESSAGE()
		End 
		RaisError (@sError,16,1) 
		Return
	End Catch
END