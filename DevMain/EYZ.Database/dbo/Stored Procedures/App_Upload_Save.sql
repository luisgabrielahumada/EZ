CREATE PROCEDURE [dbo].[App_Upload_Save]
	@Upload varchar(50),
	@UpdatedId [int],
	@Body varbinary (max),
	@ds_file varchar(250)
--WITH ENCRYPTION
AS
BEGIN
		/*------------------------------------------------------------------------------
		-- getting xml main list only range: records_[begin,end], setting record status.
		------------------------------------------------------------------------------*/
	Declare  @sError  Varchar(Max)  ,@IsErrorTecnichal int
	Execute C_Parameter_Get @CodeParameter= 'ERROR_TECNICHAL', @Value= @IsErrorTecnichal OUTPUT
	
	Begin Try
	Begin Transaction
		if  exists(Select * from [AppUploads] where Upload=@Upload) 
		Begin
				Delete From [AppUploads] where Upload=@Upload
		End
			INSERT INTO [dbo].[AppUploads]
					   ([Upload]
					   ,[Body]
					   ,[UpdatedId],FileName)
				 VALUES
					   (@Upload 
					   ,@Body 
					   ,@UpdatedId,@ds_file)
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
		--Getting the error description
		Set @sError  =   ERROR_MESSAGE()
		if @IsErrorTecnichal=1
		Begin
			Set @sError  =   ERROR_PROCEDURE() + 
					';  ' + convert(varchar,ERROR_LINE()) + 
					'; ' + ERROR_MESSAGE()
		End 
		RaisError (@sError,16,1) 
		Return
	End Catch
End