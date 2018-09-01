CREATE PROCEDURE [dbo].[DB_AvailableOpenVessels_Save]
	@Token uniqueidentifier,
	@NextOpeningOn Date=null,
	@NextOpeningPort Date,
	@CurrentPortId [int],
	@CurrentTerminalId int,
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
	Declare  @sError Varchar(Max) ,@IsErrorTecnichal int,@VesselId int
	Execute C_Parameter_Get @CodeParameter= 'ERROR_TECNICHAL', @Value= @IsErrorTecnichal OUTPUT
	-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	Begin Try
	--------------------------------------------------------------------------------
	-- Insert or Update Record
	--------------------------------------------------------------------------------
	Select @VesselId=Id
	From Vessel
	Where Vessel.Token=@Token
	Begin Transaction
		Update dbo.AvailableOpenVessels 
		Set IsActive=0,
		    Updated=getdate(),
			IsAvailable=0,
			UpdatedId=@UpdatedId
		Where VesselId=@VesselId

		INSERT INTO [dbo].[AvailableOpenVessels]
				   ([NextOpeningOn]
				   ,[NextOpeningPort]
				   ,[VesselId]
				   ,[CurrentPortId]
				   ,CurrentTerminalId
				   ,[IsAvailable]
				   ,[Creation]
				   ,[UpdatedId])
			 VALUES
				   (@NextOpeningOn
				   ,@NextOpeningPort
				   ,@VesselId
				   ,@CurrentPortId
				   ,@CurrentTerminalId
				   ,1
				   ,Getdate()
				   ,@UpdatedId)
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