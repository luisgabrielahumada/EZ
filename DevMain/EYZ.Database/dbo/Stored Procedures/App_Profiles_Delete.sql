﻿CREATE PROCEDURE [dbo].[App_Profiles_Delete]
	@UpdatedId [int],
	@Token uniqueidentifier
--WITH ENCRYPTION
AS
BEGIN
	/*------------------------------------------------------------------------------
	-- getting xml main list only range: records_[begin,end], setting record status.
	------------------------------------------------------------------------------*/
	Declare @sError varchar(max) ,@IsErrorTecnichal int
	Execute C_Parameter_Get @CodeParameter= 'ERROR_TECNICHAL', @Value= @IsErrorTecnichal OUTPUT
	Begin Try
	If Exists (Select top 1 * 
			   From dbo.AppUsers
					Inner Join AppProfiles On AppProfiles.ProfileId=dbo.AppUsers.ProfileId
			   Where dbo.AppProfiles.Token= @Token)
	Begin
		RaisError('Relationship of row with other table',16,1)
		Return
	End
	Begin Transaction
		Delete from AppProfiles where Token=@Token
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