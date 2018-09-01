-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

--DB_SearchVessel_Get 'bd10d71f-82f0-4fae-b525-ffb448fb8ec6',8,33
CREATE PROCEDURE [dbo].[DB_SearchVessel_Get] 
	-- Add the parameters for the stored procedure here
	   @token uniqueidentifier
	  ,@VesselId int=0
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
	Declare @sError Varchar(Max) ,@IsErrorTecnichal int,@id int
	Execute C_Parameter_Get @CodeParameter= 'ERROR_TECNICHAL', @Value= @IsErrorTecnichal OUTPUT
	-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	Begin Try
		SELECT RequestForServices.Id
			  ,RequestForServices.ProductId
	          ,Products.Name as ProductName
			  ,RequestForServices.StowageFactorId
			  ,StowageFactors.Name as StowageFactorName
			  ,StowageFactor
			  ,Products.Measure
			  ,RequestForServices.Creation
			  ,QuantityId
			  ,QuantityMT.Name as QuantityMTName
			  ,Products.MeasureQuantity
			  ,RequestForServices.Quantity
			  ,ToleranceId
			  ,Tolerance.Name as ToleranceName
			  ,RequestForServices.Terms
			  ,LoadingConditionId
			  ,LoadingCondition.Name as LoadingConditionName
			  ,UnLoadingConditionId
			  ,UnLoadingCondition.Name as UnLoadingConditionName
			  ,LoadPortId
			  ,LoadPort.Name+ ' ,'+ LoadCountry.CodeInternational as LoadPortName
			  ,LoadTerminalId
			  ,LoadTerminal.Name as LoadTerminalName
			  ,RequestForServices.LoadingRate
			  ,DischargePortId
			  ,DischargePort.Name+' ,'+ DischargeCountry.CodeInternational as DischargePortName
			  ,DischargeTerminalId
			  ,DischargeTerminal.Name as DischargeTerminalName
			  ,RequestForServices.UnLoadingRate
			  ,StartLaycan
			  ,EndLaycan
			  ,Status
			  ,(Select Name From Vessel Where ID=@VesselId) as VesselName
			  ,dbo.GetStatusRequest(RequestForServices.Id) as NewStatus
			  ,(Select CurrentPort.Name+ ' ,'+ Country.CodeInternational 
					 From ServiceLiquidations
					 Inner Join  Ports as CurrentPort On CurrentPort.Id=ServiceLiquidations.CurrentPortId
					 Inner Join Cities as Citie On CurrentPort.City=Citie.CityId
					 Inner Join Countries as Country On Country.CountryId=Citie.CountryId
					 Where ServiceLiquidations.VesselId=@VesselId and RequestForServiceId=RequestForServices.Id) as CurrentPortName
			  ,(Select Count(1) 
				From ServiceLiquidations 
				Where RequestForServiceId=RequestForServices.Id) as CountVessel 
			  ,@VesselId as VesselId, RequestForServices.HourCanalPanama,
			  (Select Count(1) 
				 From   ItemsLiquidation
						Inner Join ServiceLiquidations On ServiceLiquidations.Id=ItemsLiquidation.ServiceLiquidationId and RequestForServiceId=RequestForServices.Id
				 Where ItemsLiquidation.VesselId=@VesselId and IsNull(ItemsLiquidation.CanalPanamaDischarge,0) >0) as HourCanalPanamaDischarge,
			(Select Count(1) 
				 From   ItemsLiquidation
						Inner Join ServiceLiquidations On ServiceLiquidations.Id=ItemsLiquidation.ServiceLiquidationId and RequestForServiceId=RequestForServices.Id
				 Where ItemsLiquidation.VesselId=@VesselId and IsNull(ItemsLiquidation.CanalPanama,0) >0) as HourCanalPanama,
			 (Select Top 1 IsCurrentPort
				 From   ItemsLiquidation
				 	Inner Join ServiceLiquidations On ServiceLiquidations.Id=ItemsLiquidation.ServiceLiquidationId and RequestForServiceId=RequestForServices.Id
				 Where ItemsLiquidation.VesselId=@VesselId) as IsCurrentPort,
			(Select Top 1 ItemsLiquidation.Token
				 From   ItemsLiquidation
				 	Inner Join ServiceLiquidations On ServiceLiquidations.Id=ItemsLiquidation.ServiceLiquidationId and RequestForServiceId=RequestForServices.Id
				 Where ItemsLiquidation.VesselId=@VesselId) as TokenLiquidation
			FROM dbo.RequestForServices
			Inner join Products On Products.Id=RequestForServices.ProductId
			Inner join Conditions as LoadingCondition On LoadingCondition.Id=RequestForServices.LoadingConditionId
			Inner join Conditions  as UnLoadingCondition On UnLoadingCondition.Id=RequestForServices.UnLoadingConditionId
			Left join StowageFactors On StowageFactors.Id=RequestForServices.StowageFactorId
			Left join StowageFactorByProducts On StowageFactorByProducts.ProductId=RequestForServices.ProductId  and StowageFactors.Id=StowageFactorByProducts.StowageFactorId
			Left join QuantityMT On QuantityMT.Id=RequestForServices.QuantityId
			Left join QuantityMTByProducts On QuantityMTByProducts.ProductId=RequestForServices.ProductId and QuantityMTByProducts.QuantityMTId= QuantityMT.Id
			Inner join Tolerance On Tolerance.Id=RequestForServices.ToleranceId
			Inner join Ports as LoadPort On LoadPort.Id=RequestForServices.LoadPortId
			Inner Join Cities as LoadCitie On LoadPort.City=LoadCitie.CityId
			Inner Join Countries as LoadCountry On LoadCountry.CountryId=LoadCitie.CountryId
			Inner join Ports as DischargePort On DischargePort.Id=RequestForServices.DischargePortId
			Inner Join Cities as DischargeCitie On DischargePort.City=DischargeCitie.CityId
			Inner Join Countries as DischargeCountry On DischargeCountry.CountryId=DischargeCitie.CountryId
			Inner Join TerminalByProducts as TerminalByProductLoad On TerminalByProductLoad.ProductId=RequestForServices.ProductId
			Inner join Terminals as LoadTerminal On LoadTerminal.Id=RequestForServices.LoadTerminalId and TerminalByProductLoad.TerminalId=LoadTerminal.Id
			Inner Join TerminalByProducts as TerminalByProductDischarge On TerminalByProductDischarge.ProductId=RequestForServices.ProductId
			Inner join Terminals as DischargeTerminal On DischargeTerminal.Id=RequestForServices.DischargeTerminalId and TerminalByProductDischarge.TerminalId=DischargeTerminal.Id
		  Where RequestForServices.Token=@token
		        
	End Try
	Begin Catch
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
END