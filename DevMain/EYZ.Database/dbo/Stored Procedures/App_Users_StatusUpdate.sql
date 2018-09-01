CREATE PROCEDURE [dbo].[App_Users_StatusUpdate]
	@UpdatedId [int],
	@Token uniqueidentifier,
	@IsActive int
--WITH ENCRYPTION
AS
BEGIN
		/*------------------------------------------------------------------------------
		-- getting xml main list only range: records_[begin,end], setting record status.
		------------------------------------------------------------------------------*/
		Declare @sError varchar(max) ,@IsErrorTecnichal int
		Execute C_Parameter_Get @CodeParameter= 'ERROR_TECNICHAL', @Value= @IsErrorTecnichal OUTPUT
		if Exists(Select top 1 * from AppUsers where UserId=@UpdatedId and isnull(IsSysadmin,0)=0)
		Begin
			RaisError('Usted no tiene permisos para realizar esta operacion, debe tener acceso como Super Administrador...',16,1)
			return
		End
		Begin Try
		Begin Transaction
			Update Appusers 
				SET Updated=getdate(),
					IsActive=@IsActive
			where Token=@Token
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
			Set @sError   =  ERROR_PROCEDURE() + 
					';  ' + convert(varchar,ERROR_LINE()) + 
					'; ' + ERROR_MESSAGE()
		End 
		RaisError (@sError,16,1)   
		Return
	End Catch
END