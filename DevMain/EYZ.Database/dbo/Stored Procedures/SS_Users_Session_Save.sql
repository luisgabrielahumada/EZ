CREATE PROCEDURE [dbo].[SS_Users_Session_Save]
	@SessionId [varchar](400),
	@UserId [int]
--WITH ENCRYPTION
AS
BEGIN
	/*------------------------------------------------------------------------------
		Declares variables No se ha podido actualizar la información.  Intente de nuevo.
	------------------------------------------------------------------------------*/
	Declare @IsErrorTecnichal int, @sError varchar(max)
	Execute C_Parameter_Get @CodeParameter= 'ERROR_TECNICHAL', @Value= @IsErrorTecnichal OUTPUT
	
	/*------------------------------------------------------------------------------
		get current variable stream
	------------------------------------------------------------------------------*/
	begin try
		begin  Transaction
		if not exists(Select * from AppSessions where SessionId=@SessionId AND UserId=@UserId)
		Begin
			Insert Into AppSessions (SessionId ,Updated, Creation, UpdatedId,UserId) 
			Values (@SessionId, getdate(), getdate(),@UserId,@UserId)
			Exec [App_History_Timeline_Save]
					@SessionId =@SessionId,
					@UpdatedId =@UserId,
					@Type='USERS',
					@TimeLine='Alter_SESSION',
					@Comments='Creando session'
		End
		Else
		BEGIN
			Update AppSessions
			set Updated=getdate()
			where SessionId=@SessionId
			Exec [App_History_Timeline_Save]
					@SessionId =@SessionId,
					@UpdatedId =@UserId,
					@Type='USERS',
					@TimeLine='UPDATE_SESSION',
					@Comments='Actualizando session'
		End	
		Commit Transaction
		
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
	--/*------------------------------------------------------------------------------
	--	-- Return successful answer
	--	--------------------------------------------------------------------------------*/
	--	Select 'SessionId'= @SessionId_app
	--	/*-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
END