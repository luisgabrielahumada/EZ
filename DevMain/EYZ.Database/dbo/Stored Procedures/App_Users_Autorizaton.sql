CREATE PROCEDURE [dbo].[App_Users_Autorizaton]
	@Token uniqueidentifier,
	@Expiration [varchar](10),
	@Password [varchar](100)
--WITH ENCRYPTION
AS
BEGIN
		/*------------------------------------------------------------------------------
		-- getting xml main list only range: records_[begin,end], setting record status.
		------------------------------------------------------------------------------*/
	Declare  @sError Varchar(Max) ,@IsErrorTecnichal int,@ExpirationDate smalldatetime
	Execute C_Parameter_Get @CodeParameter= 'ERROR_TECNICHAL', @Value= @IsErrorTecnichal OUTPUT
	if Not exists(Select * from AppUsers where Token=@Token)
	Begin
		Raiserror('SQLCODE_AUTORIZATION',16,1)
		return
	End
	Begin Try
	Begin Transaction
			Set @ExpirationDate=convert(date,@Expiration)
			UPDATE AppUsers
			SET	Updated = getdate(),
				Password2=@Password,
				Expiration=@ExpirationDate
			WHERE Token=@Token
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