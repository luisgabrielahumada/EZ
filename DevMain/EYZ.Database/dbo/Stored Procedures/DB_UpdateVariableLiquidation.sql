CREATE PROCEDURE [dbo].[DB_UpdateVariableLiquidation]
	-- Add the parameters for the stored procedure here
	 @token varchar(max)
	,@RateLoading money
	,@RateUnLoading money
	,@ValueLoadingCondition float
	,@ValueUnLoadingCondition float
	,@Quantity float
	,@IfoLoadPort money
	,@MgoLoadPort money
	,@LoadingRate money
	,@UnLoadingRate money
	,@VesselSpeed money
	,@VesselIfoConsumed money
	,@VesselMgoConsumed money
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
	Declare @sError varchar(max) ,@IsErrorTecnichal int
	Execute C_Parameter_Get @CodeParameter= 'ERROR_TECNICHAL', @Value= @IsErrorTecnichal OUTPUT
	Begin Try
	Begin Transaction
		 Update ItemsLiquidation
		 Set RateLoading=@RateLoading,
			 RateUnLoading=@RateLoading,
			 ValueLoadingCondition=@ValueLoadingCondition,
			 ValueUnLoadingCondition=@ValueUnLoadingCondition,
			 Quantity=@Quantity,
			 IfoLoadPort=@IfoLoadPort,
			 MgoLoadPort=@MgoLoadPort,
			 LoadingRate=@LoadingRate,
			 UnLoadingRate=@UnLoadingRate,
			 VesselSpeed=@VesselSpeed,
			 VesselIfoConsumed=@VesselIfoConsumed,
			 VesselMgoConsumed=@VesselMgoConsumed,
			 UpdatedId=@UpdatedId
		 From ItemsLiquidation
			Inner Join ServiceLiquidations On ServiceLiquidations.Id=ItemsLiquidation.ServiceLiquidationId
		 Where ServiceLiquidations.Token=@token
	Commit Transaction

	Execute DB_SearchVessel_Step2 @tokenServiceLiquidation=@token,@ReCalcule=1,@UpdatedId=@UpdatedId
	------------------------------------------------------------------------------
	-- send back answer
	------------------------------------------------------------------------------
	-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
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
		Set @sError  =   ERROR_MESSAGE()
		if @IsErrorTecnichal=1
		Begin
			Set @sError   =  ERROR_PROCEDURE() + 
					';  ' + convert(varchar,ERROR_LINE()) + 
					'; ' + ERROR_MESSAGE()
		End 
		RaisError (@sError,16,1) 
		Return
	End Catch
END