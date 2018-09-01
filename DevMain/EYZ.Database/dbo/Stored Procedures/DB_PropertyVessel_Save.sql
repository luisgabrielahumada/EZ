CREATE PROCEDURE [dbo].[DB_PropertyVessel_Save]
	 @Token uniqueidentifier
	,@Name varchar(50)
	,@Code varchar(25)
	,@IsActive bit 
	,@UpdatedId [int] = Null
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
	IF Exists(Select Top 1 * From dbo.PropertyVessel Where Token<>@Token and Name=@Name)
	Begin
		RaisError('The duplicate key value is %s.',16,1,@Name)  
		return
	End
	--------------------------------------------------------------------------------
	-- Insert or Update Record
	--------------------------------------------------------------------------------
	Begin Transaction
	IF Not Exists(Select Top 1 * From dbo.PropertyVessel Where Token=@Token)
	Begin
		INSERT INTO [dbo].[PropertyVessel]
				   ([Token]
				   ,[Name]
				   ,[Code]
				   ,[Creation]
				   ,[Updated]
				   ,[IsActive]
				   ,[UpdatedId])
			 VALUES
				   (NEWID()
				   ,@Name
				   ,@Code
				   ,getdate()
				   ,getdate()
				   ,@IsActive
				   ,@UpdatedId)
	End
	Else
	Begin
		UPDATE [dbo].[PropertyVessel]
		   SET [Name] = @Name
			  ,[Code] = @Code
			  ,[Updated] = getdate()
			  ,[IsActive] = @IsActive
			  ,[UpdatedId] = @UpdatedId
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