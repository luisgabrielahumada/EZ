CREATE PROCEDURE [dbo].[DB_Cities_Save]
	@Token uniqueidentifier,
	@CountryId [int],
	@IsActive [int],
	@City [varchar](255) = Null,
	@UpdatedId [int] = Null
--WITH ENCRYPTION
AS
Begin
	--------------------------------------------------------------------------------
	-- IMPORTANT: Set this option ON: if do you wants stop and rollback transaction.
	--------------------------------------------------------------------------------
	SET XACT_ABORT ON
	--------------------------------------------------------------------------------
	-- Declaration of Variables
	--------------------------------------------------------------------------------
	Declare  @sError Varchar(Max) ,@IsErrorTecnichal int
	Execute C_Parameter_Get @CodeParameter= 'ERROR_TECNICHAL', @Value= @IsErrorTecnichal OUTPUT
	-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	Begin Try
	IF Exists(Select Top 1 * From dbo.Cities Where Token<>@Token and City=@City)
	Begin
		RaisError('The duplicate key value is %s.',16,1,@City)  
		return
	End
	--------------------------------------------------------------------------------
	-- Insert or Update Record
	--------------------------------------------------------------------------------
	Begin Transaction
	IF Not Exists(Select Top 1 * From dbo.Cities Where Token=@Token)
	Begin
		Insert Into dbo.Cities(City,CountryId,Created,IsActive,UpdatedId,Updated)
		Values (@City,@CountryId,  GETDATE(),@IsActive	,@UpdatedId,GetDate())
	End
	Else
	Begin
	
		Update dbo.Cities
		Set	City = @City,
			CountryId = @CountryId,
			IsActive = @IsActive,
			UpdatedId= @UpdatedId,
			Updated = GetDate()
		Where Token =  @Token
		If @@rowcount= 0
		Begin
			RaisError('SQLUPDATE_FAILD',16,1)  
		End
	End
	Commit Transaction
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
		RaisError(@sError,16,1)  
		Return  
	End Catch
	--------------------------------------------------------------------------------
	-- Returning a Primary Key Value
	--------------------------------------------------------------------------------
	-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
End