CREATE PROCEDURE [dbo].[DB_StowageFactor_Save]
	 @Token uniqueidentifier
	,@Name varchar(100)
	,@Value Float
	,@IsActive bit 
	,@Products varchar(max)
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
	Declare  @sError Varchar(Max) ,@IsErrorTecnichal int,@Id int
	Execute C_Parameter_Get @CodeParameter= 'ERROR_TECNICHAL', @Value= @IsErrorTecnichal OUTPUT
	-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	Begin Try
	IF Exists(Select Top 1 * From dbo.StowageFactors Where Token<>@Token and Name=@Name)
	Begin
		RaisError('The duplicate key value is %s.',16,1,@Name)  
		return
	End
	--------------------------------------------------------------------------------
	-- Insert or Update Record
	--------------------------------------------------------------------------------
	Select @Id=Id From dbo.StowageFactors Where Token=@Token
	Begin Transaction
	IF Not Exists(Select Top 1 * From dbo.StowageFactors Where Token=@Token)
	Begin
		INSERT INTO [dbo].[StowageFactors]
				   ([Token]
				   ,[Name]
				   ,[Value]
				   ,[Creation]
				   ,[Updated]
				   ,[IsActive]
				   ,[UpdatedId])
			 VALUES
				   (NewId()
				   ,@Name
				   ,@Value
				   ,getdate()
				   ,getdate()
				   ,@IsActive
				   ,@UpdatedId)
			Set @Id=SCOPE_IDENTITY()
	End
	Else
	Begin
		UPDATE [dbo].[StowageFactors]
		   SET [Token] = @Token
			  ,[Name] = @Name
			  ,[Value] = @Value
			  ,[Updated] = getdate()
			  ,[IsActive] = @IsActive
			  ,[UpdatedId] = @UpdatedId
		Where Token =  @Token
		If @@rowcount= 0
		Begin
			RaisError('SQLUPDATE_FAILD',16,1)  
		End
	End
	Delete QP From StowageFactorByProducts  as QP
			Inner Join dbo.StowageFactors On dbo.StowageFactors.Id=QP.StowageFactorId
	Where dbo.StowageFactors.Id=@Id 
	INSERT INTO [dbo].[StowageFactorByProducts]
				([Token]
				,[ProductId]
				,[StowageFactorId]
				,[Creation]
				,[Updated]
				,[IsActive]
				,[UpdatedId])
	Select NewId(), item,@Id, getdate(),getdate(),1,@UpdatedId  from [dbo].[TableSplit](@Products,',')
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