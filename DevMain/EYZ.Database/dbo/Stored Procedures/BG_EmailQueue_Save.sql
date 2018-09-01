CREATE PROCEDURE [dbo].[BG_EmailQueue_Save]
	 @ToEmail varchar(max)
	,@Subject varchar(250) =''
	,@Body varchar(max) =''
	,@Email_admin varchar(max) =''
	,@EmailTo varchar(50)
	,@UpdatedId int 
--WITH ENCRYPTION
AS
BEGIN
		/*------------------------------------------------------------------------------
		-- getting xml main list only range: records_[begin,end], setting record status.
		------------------------------------------------------------------------------*/
	Declare  @sError Varchar(Max) ,@IsErrorTecnichal int,@Email_paremters varchar(250),@Uri_paremters varchar(250)
	Execute C_Parameter_Get @CodeParameter= 'ERROR_TECNICHAL', @Value= @IsErrorTecnichal OUTPUT
	Execute C_Parameter_Get @CodeParameter= 'EMAIL_ADMIN', @Value= @Email_paremters OUTPUT
	
	Begin Try
	Begin Transaction
	Select @Email_admin=Case When @Email_admin='' then @Email_paremters else @Email_admin end
	Select @Subject=(Case When Isnull(@Subject,'')='' then AppEmailBody.Name else @Subject end),
		   @Body=Case When Isnull(@Body,'')='' then Body else @Body end
	From AppEmailBody
	Where EmailTo=@EmailTo

				INSERT INTO [dbo].[AppSendEmail]
						   ([ToEmail]
						   ,[Subject]
						   ,[Body]
						   ,[Updated]
						   ,[Creation]
						   ,[UpdatedId]
						   ,[StatusSend]
						   ,[Message]
						   ,[EmailAdmin]
						   ,[EmailTo])
					 VALUES
						   (@ToEmail 
						   ,@Subject 
						   ,@Body 
						   ,getdate()
						   ,getdate()
						   ,@UpdatedId 
						   ,'PROCESS'
						   ,null
						   ,@Email_admin 
						   ,@EmailTo )
	Commit Transaction
	------------------------------------------------------------------------------
	-- send back answer
	------------------------------------------------------------------------------
	-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
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
		Set @sError  =   ERROR_MESSAGE()
		if @IsErrorTecnichal=1
		Begin
			Set @sError   =  ERROR_PROCEDURE() + 
					';  ' + convert(varchar,ERROR_LINE()) + 
					'; ' + ERROR_MESSAGE()
		End 
		--Getting the error description
		RaisError (@sError,16,1)
		Return
	End Catch
END