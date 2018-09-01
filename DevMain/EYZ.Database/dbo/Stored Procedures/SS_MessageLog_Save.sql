CREATE PROCEDURE [dbo].[SS_MessageLog_Save]
	@Message [varchar](max),
	@Description [varchar](max),
	@StatusCode [varchar](50),
	@Body varchar(max),
	@Token uniqueidentifier
--WITH ENCRYPTION
AS
BEGIN
	/*------------------------------------------------------------------------------
		Declares variables No se ha podido actualizar la información.  Intente de nuevo.
	------------------------------------------------------------------------------*/
	Declare @IsErrorTecnichal int, @sError varchar(max),@in_error_emaill int,@ds_admin_emaill varchar(250)
	Execute C_Parameter_Get @CodeParameter= 'ERROR_TECNICHAL', @Value= @IsErrorTecnichal OUTPUT
	Execute C_Parameter_Get @CodeParameter= 'EMAIL_ERROR', @Value= @in_error_emaill OUTPUT
	Execute C_Parameter_Get @CodeParameter= 'EMAIL_ADMIN', @Value= @ds_admin_emaill OUTPUT
	
	/*------------------------------------------------------------------------------
		get current variable stream
	------------------------------------------------------------------------------*/
	begin try
		begin  Transaction
	INSERT INTO [dbo].[AppMessageLog]
           ([Message]
           ,[Description]
           ,[Creation]
           ,[StatusCode],Body,Token)
      Select
           @Message 
           ,@Description 
           ,getdate() 
           ,@StatusCode ,@Body,@Token
		Commit Transaction

		if @in_error_emaill=1
		Exec BG_EmailQueue_Save
			 @ToEmail =@ds_admin_emaill
			,@EmailTo ='SEND_ERROR'
			,@UpdatedId =0 
			,@Body=@Description
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