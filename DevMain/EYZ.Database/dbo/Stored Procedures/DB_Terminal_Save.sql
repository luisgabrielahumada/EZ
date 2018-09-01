CREATE PROCEDURE [dbo].[DB_Terminal_Save]
	 @Token uniqueidentifier
	,@PortId int 
	,@Name varchar(25) 
	,@Address varchar(200) 
	,@Contants varchar(200) 
	,@CityId int 
	,@Phone varchar(50) 
	,@Xaxis float 
	,@Yaxis float 
	,@Email varchar(80) 
	,@IsActive bit 
	,@ConditionId int 
	,@ConditionValue float 
	,@Products varchar(max)
	,@UpdatedId [int] = Null
	,@RankRate varchar(max)=''
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
	Declare  @sError Varchar(Max) ,@IsErrorTecnichal int, @Id int,@id_record int,@Count int, @item varchar(max)
	Declare  @LoadingRate money, @UnLoadingRate money, @ProductId int
	Declare @Minimum float ,@Maximum float, @Rate float
	Execute C_Parameter_Get @CodeParameter= 'ERROR_TECNICHAL', @Value= @IsErrorTecnichal OUTPUT
	-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	Begin Try
	IF Exists(Select Top 1 * From dbo.Terminals Where Token<>@Token and Name=@Name)
	Begin
		RaisError('The duplicate key value is %s.',16,1,@Name)  
		return
	End
	--------------------------------------------------------------------------------
	-- Insert or Update Record
	--------------------------------------------------------------------------------
	Begin Transaction
	IF Not Exists(Select Top 1 * From dbo.Terminals Where Token=@Token)
	Begin
			INSERT INTO [dbo].[Terminals]
					   ([Token]
					   ,[PortId]
					   ,[Name]
					   ,[Address]
					   ,[Contants]
					   ,[CityId]
					   ,[Phone]
					   ,[Xaxis]
					   ,[Yaxis]
					   ,[Email]
					   ,[Creation]
					   ,[Updated]
					   ,[IsActive]
					   ,[UpdatedId]
					   ,[ConditionId]
					   ,[ConditionValue])
				 VALUES
					   (NewId()
					   ,@PortId   
					   ,@Name 
					   ,@Address 
					   ,@Contants 
					   ,@CityId 
					   ,@Phone 
					   ,@Xaxis   
					   ,@Yaxis   
					   ,@Email 
					   ,getdate()
					   ,getdate()
					   ,@IsActive   
					   ,@UpdatedId   
					   ,@ConditionId   
					   ,@ConditionValue   )
			Set @Id= SCOPE_IDENTITY()

			
	End
	Else
	Begin
	UPDATE [dbo].[Terminals]
	   SET [Token] = @Token 
		  ,[PortId] = @PortId 
		  ,[Name] = @Name 
		  ,[Address] = @Address 
		  ,[Contants] = @Contants 
		  ,[CityId] = @CityId 
		  ,[Phone] = @Phone 
		  ,[Xaxis] = @Xaxis 
		  ,[Yaxis] = @Yaxis 
		  ,[Email] = @Email 
		  ,[Updated] = getdate()
		  ,[IsActive] = @IsActive 
		  ,[UpdatedId] = @UpdatedId 
		  ,[ConditionId] = @ConditionId 
		  ,[ConditionValue] = @ConditionValue 
		Where Token =  @Token

		Select  @Id= Id
		From [dbo].[Terminals]
		Where Token =  @Token

		If @@rowcount= 0
		Begin
			RaisError('SQLUPDATE_FAILD',16,1)  
		End
	End
	
	Delete From TerminalByProducts where TerminalId=@Id
	Select @Count=Count(1) From [dbo].[TableSplit](@Products,'x')
	Set @id_record=1
	While(@Count>=@id_record)
	Begin

		Select @item=item
		From [dbo].[TableSplit](@Products,'x')
		Where id_record=@id_record
		Select @ProductId=Convert(int,item) From [dbo].[TableSplit](@item,'|') Where id_record=1
		Select @LoadingRate=Convert(money,item)  From [dbo].[TableSplit](@item,'|') Where id_record=2
		Select @UnLoadingRate=Convert(money,item)  From [dbo].[TableSplit](@item,'|') Where id_record=3
		Select @IsActive=Convert(bit,item)  From [dbo].[TableSplit](@item,'|') Where id_record=4

		INSERT INTO [dbo].[TerminalByProducts]
					([Token]
					,[TerminalId]
					,[ProductId]
					,[LoadingRate]
					,[UnloadingRate]
					,[Creation]
					,[IsActive]
					,[UpdatedId])
		Select NewId(), @Id,@ProductId,@LoadingRate,@UnLoadingRate,getdate(),@IsActive,@UpdatedId  
		Set @id_record=@id_record+1 

		
	End

	Delete From RankRateTerminals where TerminalId=@Id
	Select @Count=Count(1) From [dbo].[TableSplit](@RankRate,'x')
	Set @id_record=1
	While(@Count>=@id_record)
	Begin

		Select @item=item
		From [dbo].[TableSplit](@RankRate,'x')
		Where id_record=@id_record

	
		Select @Minimum=Convert(int,item) From [dbo].[TableSplit](@item,'|') Where id_record=1
		Select @Maximum=Convert(money,item)  From [dbo].[TableSplit](@item,'|') Where id_record=2
		Select @Rate=Convert(money,item)  From [dbo].[TableSplit](@item,'|') Where id_record=3

		INSERT INTO [dbo].[RankRateTerminals]
					([Token]
					,[TerminalId]
					,[Minimum]
					,[Maximum]
					,[Rate]
					,[Creation]
					,[IsActive]
					,[UpdatedId])
		Select NewId(), @Id,@Minimum,@Maximum,@Rate,getdate(),1,@UpdatedId  
		Set @id_record=@id_record+1

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