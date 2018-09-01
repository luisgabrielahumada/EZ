-- =============================================
-- Author:		@Author,,Name>
-- Create date: @Create Date,,>
-- Description:	@Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DB_SearchVessel_Step1] 
	-- Add the parameters for the stored procedure here
	   @Token uniqueidentifier
	  ,@ProductId int
      ,@StowageFactorId int
      ,@StowageFactor float
      ,@QuantityId int
      ,@Quantity float
      ,@ToleranceId int
      ,@Terms int
      ,@LoadingConditionId int
      ,@UnLoadingConditionId int
      ,@LoadPortId int
      ,@LoadTerminalId int
      ,@LoadingRate money
      ,@DischargePortId int
      ,@DischargeTerminalId int
      ,@UnLoadingRate money
      ,@StartLaycan datetime
      ,@EndLaycan datetime
      ,@UpdatedId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--------------------------------------------------------------------------------
	-- IMPORTANT: Set this option ON: if do you wants stop and rollback transaction.
	--------------------------------------------------------------------------------
	SET XACT_ABORT ON
	SET NOCOUNT ON;
	--------------------------------------------------------------------------------
	-- Declaration of Variables
	--------------------------------------------------------------------------------
	Declare @sError Varchar(Max) ,@IsErrorTecnichal int,@id int,@HourCanalPanama float
	Execute C_Parameter_Get @CodeParameter= 'ERROR_TECNICHAL', @Value= @IsErrorTecnichal OUTPUT
	-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	Begin Try
	--------------------------------------------------------------------------------
	-- Insert or Update Record
	--------------------------------------------------------------------------------
	Begin Transaction

		Select Top 1 @HourCanalPanama=HourCanalPanama
		from DistanceBetweenPorts 
		Where InputPortId =@LoadPortId and OutPutPortId=@DischargePortId
		if @StowageFactorId!='9999999'
		Begin
			Select @StowageFactor=StowageFactors.Value
			From StowageFactors
				Inner join StowageFactorByProducts On StowageFactorByProducts.ProductId=@ProductId  
						and StowageFactorByProducts.StowageFactorId=StowageFactors.Id
						and StowageFactors.Id=@StowageFactorId
		End
		if @QuantityId!='9999999'
		Begin
		  Select @Quantity=QuantityMT.Quantity
		  From QuantityMT
				Inner join QuantityMTByProducts On QuantityMTByProducts.ProductId=@ProductId 
					and QuantityMTByProducts.QuantityMTId= QuantityMT.Id
					and QuantityMT.Id= @QuantityId
		End

		if Not Exists (Select Top 1 Rate 
						From RankRateTerminals 
						Where @Quantity between Minimum and Maximum And TerminalId=@LoadTerminalId)
		Begin
			raiserror('Port Cost for load terminal is not defined for this quantity',16,1)
			return
		End

		if Not Exists (Select Top 1 Rate 
						From RankRateTerminals 
						Where @Quantity between Minimum and Maximum And TerminalId=@DischargeTerminalId)
		Begin
			raiserror('Port Cost for load terminal is not defined for this quantity',16,1)
			return
		End
		
		
		if Not Exists (Select top 1 Id From [RequestForServices] Where token=@Token)
		Begin 
			INSERT INTO [dbo].[RequestForServices]
					   ([ProductId]
					   ,[StowageFactorId]
					   ,[StowageFactor]
					   ,[Creation]
					   ,[QuantityId]
					   ,[Quantity]
					   ,[ToleranceId]
					   ,[Terms]
					   ,[LoadingConditionId]
					   ,[UnLoadingConditionId]
					   ,[LoadPortId]
					   ,[LoadTerminalId]
					   ,[LoadingRate]
					   ,[DischargePortId]
					   ,[DischargeTerminalId]
					   ,[UnLoadingRate]
					   ,[StartLaycan]
					   ,[EndLaycan]
					   ,[Status]
					   ,[UpdatedId]
					   ,Owner
					   ,HourCanalPanama)
				 VALUES
					   (@ProductId
					   ,@StowageFactorId
					   ,@StowageFactor
					   ,getdate()
					   ,@QuantityId
					   ,@Quantity
					   ,@ToleranceId
					   ,@Terms
					   ,@LoadingConditionId
					   ,@UnLoadingConditionId
					   ,@LoadPortId
					   ,@LoadTerminalId
					   ,@LoadingRate
					   ,@DischargePortId
					   ,@DischargeTerminalId
					   ,@UnLoadingRate
					   ,@StartLaycan
					   ,@EndLaycan
					   ,'REQUEST'
					   ,@UpdatedId
					   ,@UpdatedId
					   ,@HourCanalPanama)
				  Set @id=SCOPE_IDENTITY()
			End
			Else
			Begin
					UPDATE [dbo].[RequestForServices]
					SET [ProductId] = @ProductId
						  ,[StowageFactorId] = @StowageFactorId
						  ,[StowageFactor] = @StowageFactor
						  ,[QuantityId] = @QuantityId
						  ,[Quantity] = @Quantity
						  ,[ToleranceId] = @ToleranceId
						  ,[Terms] = @Terms
						  ,[LoadingConditionId] = @LoadingConditionId
						  ,[UnLoadingConditionId] = @UnLoadingConditionId
						  ,[LoadPortId] = @LoadPortId
						  ,[LoadTerminalId] = @LoadTerminalId
						  ,[LoadingRate] = @LoadingRate 
						  ,[DischargePortId] = @DischargePortId
						  ,[DischargeTerminalId] = @DischargeTerminalId
						  ,[UnLoadingRate] = @UnLoadingRate
						  ,[StartLaycan] = @StartLaycan
						  ,[EndLaycan] = @EndLaycan
						  ,[Owner] = @UpdatedId
						  ,HourCanalPanama=@HourCanalPanama
				WHERE token=@Token

				Select @id=Id
				From [dbo].[RequestForServices]
				Where token=@token
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
	Select  token
	From [RequestForServices]
	Where id=@id
	-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
END