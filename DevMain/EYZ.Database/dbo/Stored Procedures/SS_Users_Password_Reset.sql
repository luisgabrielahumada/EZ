CREATE PROCEDURE [dbo].[SS_Users_Password_Reset]
	@SessionId [varchar](100),
	@UpdatedId int=0
--WITH ENCRYPTION
AS
BEGIN
		/*------------------------------------------------------------------------------
		-- declaracion de variables
		--------------------------------------------------------------------------------*/
	Declare @IsErrorTecnichal int, @sError varchar(max), @UserId int
	Execute C_Parameter_Get @CodeParameter= 'ERROR_TECNICHAL', @Value= @IsErrorTecnichal OUTPUT
	BEGIN TRY
		if Exists(Select Login 
						From Appusers 
						Inner Join AppSessions On AppSessions.SessionId=@SessionId
						where Appusers.UserId=AppSessions.UserId and IsBlock=1 and AppUsers.UserId=@UpdatedId)
		Begin
			RaisError('Para realizar el reseteo de claves usted no tiene permisos.',16,1) 
    	    Return 
		End
		Select @UserId=AppUsers.UserId
		From AppUsers
		Inner Join AppSessions On AppSessions.SessionId=@SessionId
		Where AppUsers.UserId=AppSessions.UserId

		Update AppUsers
		Set AppUsers.Password=Reset 
		From AppUsers
		Inner Join AppSessions On AppSessions.SessionId=@SessionId
		Where AppUsers.UserId=AppSessions.UserId


			Exec [App_History_Timeline_Save]
					@SessionId =@SessionId,
					@UpdatedId =@UserId,
					@Type='USERS',
					@TimeLine='RESET_PASSWORD',
					@Comments='Reiniciando la clave del usuario'
	END TRY
	Begin Catch
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