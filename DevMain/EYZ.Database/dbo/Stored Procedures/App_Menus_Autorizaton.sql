CREATE PROCEDURE [dbo].[App_Menus_Autorizaton]
	@UserId [int],
	@Password [varchar](100)
--WITH ENCRYPTION
AS
BEGIN
		/*------------------------------------------------------------------------------
		-- getting xml main list only range: records_[begin,end], setting record status.
		------------------------------------------------------------------------------*/
	Declare  @sError Varchar(Max) ,@IsErrorTecnichal int,@dt_expiration_date smalldatetime
	Execute C_Parameter_Get @CodeParameter= 'ERROR_TECNICHAL', @Value= @IsErrorTecnichal OUTPUT
	if Not exists(Select * from appusers where UserId=@UserId)
	Begin
		Raiserror('SQLUSERCODE_AUTORIZATION',16,1)
		return
	End
	if Not exists(Select * from appusers where UserId=@UserId AND Password2=@Password)
	Begin
		Raiserror('SQLVALIDATE_AUTORIZATION',16,1)
		return
	End
	if  exists(Select * from appusers where UserId=@UserId AND Password2=@Password and datediff(day,getdate(),Expiration)<=0)
	Begin
		Raiserror('SQLVALIDATE_AUTORIZATION',16,1)
		return
	End
	Begin Try
	
	Select * from Appusers where UserId=@UserId AND Password2=@Password 
	------------------------------------------------------------------------------
	-- send back answer
	------------------------------------------------------------------------------
	-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	End Try
	Begin Catch
		-- there was an error
		Set @sError  =  ERROR_MESSAGE()
		if @IsErrorTecnichal=1
		Begin
			Set @sError  =  ERROR_PROCEDURE() + 
					';  ' + convert(varchar,ERROR_LINE()) + 
					'; ' + ERROR_MESSAGE()
		End 
		--Getting the error description
		RaisError (@sError,16,1)
		Return
	End Catch
END