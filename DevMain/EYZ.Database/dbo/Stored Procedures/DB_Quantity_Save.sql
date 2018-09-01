CREATE PROCEDURE [dbo].[DB_Quantity_Save]
	 @Token uniqueidentifier
	,@Name varchar(50)
	,@Quantity float
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
	IF Exists(Select Top 1 * From dbo.QuantityMT Where Token<>@Token and Name=@Name)
	Begin
		RaisError('The duplicate key value is %s.',16,1,@Name)  
		return
	End
	--------------------------------------------------------------------------------
	-- Insert or Update Record
	--------------------------------------------------------------------------------
	Select @Id=Id From dbo.QuantityMT Where Token=@Token
	Begin Transaction
	IF Not Exists(Select Top 1 * From dbo.QuantityMT Where Token=@Token)
	Begin
		INSERT INTO [dbo].[QuantityMT]
				   ([Token]
				   ,[Name]
				   ,[Quantity]
				   ,[Creation]
				   ,[Updated]
				   ,[IsActive]
				   ,[UpdatedId])
			 VALUES
				   (NewId()
				   ,@Name
				   ,@Quantity
				   ,getdate()
				   ,getdate()
				   ,@IsActive
				   ,@UpdatedId)
			Set @Id=SCOPE_IDENTITY()
	End
	Else
	Begin
		UPDATE [dbo].[QuantityMT]
		   SET [Token] = @Token
			  ,[Name] = @Name
			  ,[Quantity] = @Quantity
			  ,[Updated] = getdate()
			  ,[IsActive] = @IsActive
			  ,[UpdatedId] = @UpdatedId
		Where Token =  @Token
		If @@rowcount= 0
		Begin
			RaisError('SQLUPDATE_FAILD',16,1)  
		End
	End
	Delete QP From QuantityMTByProducts  as QP
			Inner Join dbo.QuantityMT On dbo.QuantityMT.Id=QP.QuantityMTId
	Where dbo.QuantityMT.Id=@Id 
	INSERT INTO [dbo].[QuantityMTByProducts]
				([Token]
				,[ProductId]
				,[QuantityMTId]
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