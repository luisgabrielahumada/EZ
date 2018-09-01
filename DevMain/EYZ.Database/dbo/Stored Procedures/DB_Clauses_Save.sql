Create PROCEDURE [dbo].[DB_Clauses_Save]
	 @Token uniqueidentifier
	,@Name varchar(max)
	,@Code varchar(50) 
	,@IsModify bit 
	,@IsActive bit 
	,@UpdatedId [int] = Null
AS
Begin
	--------------------------------------------------------------------------------
	-- IMPORTANT: Set this option ON: if do you wants stop and rollback transaction.
	--------------------------------------------------------------------------------
	SET XACT_ABORT ON
	--------------------------------------------------------------------------------
	-- Declaration of Variables
	--------------------------------------------------------------------------------
	Declare  @sError Varchar(Max) ,@IsErrorTecnichal int, @Id int
	Execute C_Parameter_Get @CodeParameter= 'ERROR_TECNICHAL', @Value= @IsErrorTecnichal OUTPUT
	-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	Begin Try
	--------------------------------------------------------------------------------
	-- Insert or Update Record
	--------------------------------------------------------------------------------
	Begin Transaction
	IF Not Exists(Select Top 1 * From dbo.Clauses Where Token=@Token)
	Begin
		INSERT INTO [dbo].[Clauses]
					([Code]
					,[Name]
					,[IsModify]
					,[IsActive]
					,[UpdatedId])
				VALUES
					(@Code
					,@Name
					,@IsModify
					,@IsActive
					,@UpdatedId)

		Set @Id=SCOPE_IDENTITY()
	End
	Else
	Begin
		UPDATE [dbo].[Clauses]
		   SET [Code] = @Code
			  ,[Name] =  @Name
			  ,[IsModify] =  @IsModify
			  ,[IsActive] =  @IsActive
			  ,[Updated] =  getdate()
			  ,[UpdatedId] =  @UpdatedId
		 WHERE Token=@Token
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