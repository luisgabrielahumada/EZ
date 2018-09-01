CREATE PROCEDURE [dbo].[DB_Contract_Save]
	 @Token uniqueidentifier
	,@Name varchar(max)
	,@Code varchar(50) 
	,@Observation varchar(max)=''
	,@AvailableFrom date=null
	,@IsActive bit 
	,@UpdatedId [int] = Null
	,@Clauses varchar(max)=''
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
	Select @Id=Id From dbo.[Contract] Where Token=@Token
	Begin Transaction
	IF Not Exists(Select Top 1 * From dbo.Contract Where Token=@Token)
	Begin
		INSERT INTO [dbo].[Contract]
				   ([Code]
				   ,[Name]
				   ,[Observation]
				   ,[AvailableFrom]
				   ,[IsActive]
				   ,[UpdatedId])
			 VALUES
				   (@Code
				   ,@Name
				   ,@Observation
				   ,@AvailableFrom
				   ,@IsActive
				   ,@UpdatedId)
		Set @Id=SCOPE_IDENTITY()
	End
	Else
	Begin
		UPDATE [dbo].[Contract]
		   SET [Code] = @Code
			  ,[Name] = @Name
			  ,[Observation] = @Observation
			  ,[AvailableFrom] = @AvailableFrom
			  ,[IsActive] = @IsActive
			  ,[Updated] = getdate()
			  ,[UpdatedId] = @UpdatedId
		 WHERE Token=@Token
		If @@rowcount= 0
		Begin
			RaisError('SQLUPDATE_FAILD',16,1)  
		End
	End

	Delete QP From ContractClauses  as QP
			Inner Join dbo.Contract On dbo.Contract.Id=QP.ContractId
	Where dbo.Contract.Id=@Id 

	INSERT INTO [dbo].[ContractClauses]
			   ([ClauseId]
			   ,[ContractId]
			   ,[Token]
			   ,[Creation]
			   ,[UpdatedId])
	Select item,@Id,NewId(),  getdate(),@UpdatedId  
	From [dbo].[TableSplit](@Clauses,'|')

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