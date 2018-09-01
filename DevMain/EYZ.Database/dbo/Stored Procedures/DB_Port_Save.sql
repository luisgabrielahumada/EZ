CREATE PROCEDURE [dbo].[DB_Port_Save]
	 @Token uniqueidentifier
	,@Name varchar(25)
	,@Address varchar(200) 
	,@Phone varchar(50) 
	,@City int 
	,@Ifo money 
	,@Mgo money
	,@Terms varchar(max) 
	,@IsActive bit 
	,@UpdatedId [int] = Null
	,@Draft money
	,@Dwt money
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
	Declare  @sError Varchar(Max) ,@IsErrorTecnichal int, @Id int
	Execute C_Parameter_Get @CodeParameter= 'ERROR_TECNICHAL', @Value= @IsErrorTecnichal OUTPUT
	-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	Begin Try
	--------------------------------------------------------------------------------
	-- Insert or Update Record
	--------------------------------------------------------------------------------
	Begin Transaction
	IF Not Exists(Select Top 1 * From dbo.Ports Where Token=@Token)
	Begin
			INSERT INTO [dbo].[Ports]
					   ([Token]
					   ,[Name]
					   ,[Address]
					   ,[Phone]
					   ,[City]
					   ,[Ifo]
					   ,[Mgo]
					   ,[Terms]
					   ,[Creation]
					   ,[Updated]
					   ,[IsActive]
					   ,[UpdatedId],Draft,Dwt)
				 VALUES
					   (NewId()
					   ,@Name
					   ,@Address
					   ,@Phone
					   ,@City
					   ,@Ifo
					   ,@Mgo
					   ,@Terms
					   ,GETDATE()
					   ,GETDATE()
					   ,@IsActive
					   ,@UpdatedId,@Draft,@Dwt)
		Set @Id=SCOPE_IDENTITY()
		INSERT INTO [dbo].[DistanceBetweenPorts]
           ([Token]
           ,[InputPortId]
           ,[OutPutPortId]
           ,[Interval]
           ,[Updated]
           ,[Created]
           ,[IsActive]
           ,[UpdatedId]
           ,[HourCanalPanama])
		Select NewId(),@Id,Id,0,null,getdate(),1,@UpdatedId,0
		From Ports
		Where Id<>@Id

		INSERT INTO [dbo].[DistanceBetweenPorts]
           ([Token]
           ,[InputPortId]
           ,[OutPutPortId]
           ,[Interval]
           ,[Updated]
           ,[Created]
           ,[IsActive]
           ,[UpdatedId]
           ,[HourCanalPanama])
		Select NewId(),Id,@Id,0,null,getdate(),1,@UpdatedId,0
		From Ports
		Where Id<>@Id
	End
	Else
	Begin
		UPDATE [dbo].[Ports]
		   SET [Token] = @Token
			  ,[Name] =  @Name
			  ,[Address] =  @Address
			  ,[Phone] =  @Phone
			  ,[City] =  @City
			  ,[Ifo] = @Ifo
			  ,[Mgo] =  @Mgo
			  ,[Terms] =  @Terms
			  ,[Updated] =GETDATE()
			  ,[IsActive] =  @IsActive
			  ,[UpdatedId] =  @UpdatedId
			  ,Draft=@Draft
			  ,Dwt=@Dwt
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