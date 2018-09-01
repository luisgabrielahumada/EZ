CREATE PROCEDURE [dbo].[DB_DistanceBetweenPorts_Save]
	 @Items varchar(max)
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
	Declare  @sError Varchar(Max) ,@IsErrorTecnichal int, @Id int,@id_record int,@Count int, @item varchar(max)
	Declare  @InputPortId int, @OutPutPortId int
	Declare  @Interval float, @HourCanalPanama float, @IsActive bit
	Execute C_Parameter_Get @CodeParameter= 'ERROR_TECNICHAL', @Value= @IsErrorTecnichal OUTPUT
	-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	Begin Try
	--------------------------------------------------------------------------------
	-- Insert or Update Record
	--------------------------------------------------------------------------------
	Begin Transaction
	Select @Count=Count(1) From [dbo].[TableSplit](@Items,'x')
	Set @id_record=1
	While(@Count>=@id_record)
	Begin

		Select @item=item
		From [dbo].[TableSplit](@Items,'x')
		Where id_record=@id_record


			Select @InputPortId=Convert(int,item) From [dbo].[TableSplit](@item,'|') Where id_record=1
			Select @OutPutPortId=Convert(int,item) From [dbo].[TableSplit](@item,'|') Where id_record=2
			Select @Interval=Convert(float,item)  From [dbo].[TableSplit](@item,'|') Where id_record=3
			Select @HourCanalPanama=Convert(float,item)  From [dbo].[TableSplit](@item,'|') Where id_record=4
			Select @IsActive=Convert(bit,item)  From [dbo].[TableSplit](@item,'|') Where id_record=5

			UPDATE [dbo].[DistanceBetweenPorts]
			   SET [Interval] = @Interval
				  ,[Updated] = getdate()
				  ,[IsActive] = @IsActive
				  ,[UpdatedId] = @UpdatedId
				  ,[HourCanalPanama] = @HourCanalPanama
			 WHERE InputPortId=@InputPortId and OutPutPortId=@OutPutPortId

			 UPDATE [dbo].[DistanceBetweenPorts]
			   SET [Interval] = @Interval
				  ,[Updated] = getdate()
				  ,[IsActive] = @IsActive
				  ,[UpdatedId] = @UpdatedId
				  ,[HourCanalPanama] = @HourCanalPanama
			 WHERE InputPortId=@OutPutPortId and OutPutPortId=@InputPortId


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