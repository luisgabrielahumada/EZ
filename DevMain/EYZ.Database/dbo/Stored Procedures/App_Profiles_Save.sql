CREATE PROCEDURE [dbo].[App_Profiles_Save]
	@Token uniqueidentifier,
	@UpdatedId [int],
	@Profile [varchar](200),
	@Section [text],
	@IsActive [int]
--WITH ENCRYPTION
AS
BEGIN
		/*------------------------------------------------------------------------------
		-- getting xml main list only range: records_[begin,end], setting record status.
		------------------------------------------------------------------------------*/
	Declare  @sError  Varchar(Max)  ,@IsErrorTecnichal int
	Execute C_Parameter_Get @CodeParameter= 'ERROR_TECNICHAL', @Value= @IsErrorTecnichal OUTPUT
	IF Exists(Select Top 1 * From dbo.AppProfiles Where Profile=@Profile and Token<>@Token)
	Begin
		RaisError('The duplicate key value is %s.',16,1,@Profile)  
		return
	End
	Begin Try
	Begin Transaction
		if Not Exists(Select * from AppProfiles where Token=@Token) 
		Begin
			INSERT INTO  AppProfiles(Profile,Section,Creation,Updated,UpdatedId,IsActive)
			VALUES(@Profile,@Section,getdate(),getdate(),@UpdatedId,@IsActive)
			------------------------------------------------------------------------------
			-- send back answer
			------------------------------------------------------------------------------
		End
		Else
		Begin
			/*-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
			UPDATE AppProfiles
			SET	Profile = @Profile,
				Section = @Section,
				Updated = getdate(),
				UpdatedId = @UpdatedId,
				IsActive = @IsActive
			WHERE Token=@Token
		End
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