CREATE PROCEDURE [dbo].[DB_Vessel_Save]
		 @Token uniqueidentifier
		,@Name varchar(25)
		,@Description varchar(250)
		,@Phone varchar(25)
		,@Email varchar(80)
		,@Contact varchar(50)
		,@CityId int
		,@Speed float
		,@TypeId int
		,@Capacity int
		,@Demurrage money
		,@RateLoading money
		,@RateUnloading money
		,@IfoConsumed money
		,@MgoConsumed money
		,@IsActive bit
		,@Owner int
		,@UpdatedId int
		,@Products varchar(max)
		,@Property  varchar(max)
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
	Declare  @Id int
	Execute C_Parameter_Get @CodeParameter= 'ERROR_TECNICHAL', @Value= @IsErrorTecnichal OUTPUT
	-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	Begin Try
	IF Exists(Select Top 1 * From dbo.Vessel Where Token<>@Token and Name=@Name)
	Begin
		RaisError('The duplicate key value is %s.',16,1,@Name)  
		return
	End
	--------------------------------------------------------------------------------
	-- Insert or Update Record
	--------------------------------------------------------------------------------
	Begin Transaction
	IF Not Exists(Select Top 1 * From dbo.Vessel Where Token=@Token)
	Begin
		INSERT INTO [dbo].[Vessel]
				([Token]
				,[Name]
				,[Description]
				,[Phone]
				,[Email]
				,[Contact]
				,[CityId]
				,[Speed]
				,[TypeId]
				,[Capacity]
				,[Demurrage]
				,[RateLoading]
				,[RateUnloading]
				,[IfoConsumed]
				,[MgoConsumed]
				,[Creation]
				,[Updated]
				,[IsActive]
				,[Owner]
				,[UpdatedId])
			VALUES
				(NEWID() 
				,@Name 
				,@Description 
				,@Phone 
				,@Email 
				,@Contact 
				,@CityId  
				,@Speed  
				,@TypeId  
				,@Capacity  
				,@Demurrage  
				,@RateLoading  
				,@RateUnloading  
				,@IfoConsumed  
				,@MgoConsumed  
				,Getdate()
				,Getdate()
				,@IsActive  
				,@Owner  
				,@UpdatedId  )
		Set @Id= SCOPE_IDENTITY()
	End
	Else
	Begin
			UPDATE [dbo].[Vessel]
			SET [Name] = @Name
				,[Description] = @Description
				,[Phone] = @Phone
				,[Email] = @Email
				,[Contact] = @Contact
				,[CityId] = @CityId
				,[Speed] = @Speed
				,[TypeId] = @TypeId
				,[Capacity] = @Capacity
				,[Demurrage] = @Demurrage
				,[RateLoading] = @RateLoading
				,[RateUnloading] = @RateUnloading
				,[IfoConsumed] = @IfoConsumed
				,[MgoConsumed] = @MgoConsumed
				,[Updated] = Getdate()
				,[IsActive] = @IsActive 
				,[UpdatedId] = @UpdatedId
			Where Token =  @Token

			Select  @Id= Id
			From [dbo].[Vessel]
			Where Token =  @Token

			If @@rowcount= 0
			Begin
				RaisError('SQLUPDATE_FAILD',16,1)  
			End
	End

	Delete From ProductByVessels where VesselId=@Id
	INSERT INTO [dbo].[ProductByVessels]
				([Token]
				,[VesselId]
				,[ProductId]
				,[Creation]
				,[Updated]
				,[IsActive]
				,[UpdatedId])
	Select NewId(), @Id,item,Getdate(),Getdate(),1,@UpdatedId  
	From [dbo].[TableSplit](@Products,',')


	Declare @Count int,@id_record int,@item varchar(max),@PropertyVesselId int,@Value varchar(max)
	Delete From PropertyValueVessel where VesselId=@Id
	Select @Count=Count(1) From [dbo].[TableSplit](@Property,'?')
	Set @id_record=1
	While(@Count>=@id_record)
	Begin
		Select @item=item
		From [dbo].[TableSplit](@Property,'?')
		Where id_record=@id_record

		Select @PropertyVesselId=Convert(int,item) From [dbo].[TableSplit](@item,'|') Where id_record=1
		Select @Value=item  From [dbo].[TableSplit](@item,'|') Where id_record=2

		INSERT INTO [dbo].[PropertyValueVessel]
				   ([Token]
				   ,[VesselId]
				   ,[PropertyVesselId]
				   ,[Value]
				   ,[Creation]
				   ,[Updated]
				   ,[IsActive]
				   ,[UpdatedId])
		Select NewId(), @Id,@PropertyVesselId,@Value,getdate(),getdate(),1,@UpdatedId  

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