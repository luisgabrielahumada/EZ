CREATE PROCEDURE [dbo].[DB_InboxCustomer_List]
	@PageIndex [int] = 1,
	@PageSize [int] = 10,
	@TotalRecords [int] = 0 OUTPUT,
	@Owner int,
	@UpdatedId int,
	@ProductId int=0, 
	@StowageFactorId int=0, 
    @QuantityId int=0, 
	@LoadPortId int=0,  
	@LoadTerminalId int=0, 
	@DischargePortId int=0, 
	@DischargeTerminalId int=0, 
	@StartLaycan date=null,
	@EndLaycan date=null,
	@Status varchar(25)='REQUEST'
AS
Begin


	/*------------------------------------------------------------------------------
		-- getting xml main list only range: records_[begin,end], setting record status.
		--------------------------------------------------------------------------------*/
		Select @TotalRecords=count(*) 
		From RequestForServices 
			Inner Join ServiceLiquidations On ServiceLiquidations.RequestForServiceId=RequestForServices.Id And ServiceLiquidations.Status!='PENDING'
		Where RequestForServices.Owner=@Owner And ServiceLiquidations.Status=@Status
		------------------------------------------------------------------------------
		-- getting user list
		------------------------------------------------------------------------------	
		Select RequestForServices.Token, Products.Name as Product,RequestForServices.Quantity,RequestForServices.StartLaycan,RequestForServices.EndLaycan,
		  LoadPort.Name+ ' ,'+ LoadCountry.CodeInternational as LoadPort, UnLoadPort.Name+' ,'+ DischargeCountry.CodeInternational as UnLoadPort, LoadTerminal.Name as LoadTerminal,
		  UnLoadTerminal.Name as UnLoadTerminal,RequestForServices.Status, RequestForServices.Creation, RequestForServices.Id,dbo.GetStatusRequest(ServiceLiquidations.RequestForServiceId) as NewStatus,
		  (Select Count(1) from ServiceLiquidations Where ServiceLiquidations.RequestForServiceId=RequestForServices.Id And ServiceLiquidations.Status!='PENDING' ) as CountVessel ,
		  (Select Count(1) from ServiceLiquidations Where ServiceLiquidations.RequestForServiceId=RequestForServices.Id And ServiceLiquidations.Status!='PENDING' And ServiceLiquidations.Status!='REQUEST' ) as CountReponseVessel ,Products.Measure,Products.MeasureQuantity
		From RequestForServices
			Inner Join ServiceLiquidations On ServiceLiquidations.RequestForServiceId=RequestForServices.Id And ServiceLiquidations.Status!='PENDING'
			--Inner Join Vessel On ServiceLiquidations.VesselId=Vessel.Id
			Inner Join Products On Products.Id=RequestForServices.ProductId
			Left Join StowageFactors On StowageFactors.Id=RequestForServices.StowageFactorId
			Left Join QuantityMT On QuantityMT.Id=RequestForServices.QuantityId
			--Inner Join Conditions On Conditions.Id=RequestForServices.ConditionId
			Inner Join Tolerance On Tolerance.Id=RequestForServices.ToleranceId
			Inner Join Ports as LoadPort On LoadPort.Id=RequestForServices.LoadPortId
			Inner Join Cities as LoadCitie On LoadPort.City=LoadCitie.CityId
			Inner Join Countries as LoadCountry On LoadCountry.CountryId=LoadCitie.CountryId
			Inner Join Ports as UnLoadPort On UnLoadPort.Id=RequestForServices.DischargePortId
			Inner Join Cities as DischargeCitie On UnLoadPort.City=DischargeCitie.CityId
			Inner Join Countries as DischargeCountry On DischargeCountry.CountryId=DischargeCitie.CountryId
			Inner Join Terminals as LoadTerminal On LoadTerminal.Id=RequestForServices.LoadTerminalId
			Inner Join Terminals as UnLoadTerminal On UnLoadTerminal.Id=RequestForServices.DischargeTerminalId
		Where 
			(Products.Id=@ProductId or @ProductId=0) 
			And (StowageFactors.Id=@StowageFactorId or @StowageFactorId=0) 
			And (QuantityMT.Id=@QuantityId or @QuantityId=0) 
			--And (Conditions.Id=@ConditionId or @ConditionId=0) 
			And (LoadPort.Id=@LoadPortId or @LoadPortId=0) 
			And (LoadTerminal.Id=@LoadTerminalId or @LoadTerminalId=0) 
			And (UnLoadPort.Id=@DischargePortId or @DischargePortId=0) 
			And (UnLoadTerminal.Id=@DischargeTerminalId or @DischargeTerminalId=0) 
			--And (RequestForServices.StartLaycan>=@StartLaycan or @StartLaycan=null) 
			--And (RequestForServices.EndLaycan<=@EndLaycan or @EndLaycan=null) 
			And RequestForServices.Owner=@Owner
			
			--And RequestForServices.Status=@Status
		Group by RequestForServices.Token, Products.Name,RequestForServices.Quantity,RequestForServices.StartLaycan,RequestForServices.EndLaycan,
		  LoadPort.Name, UnLoadPort.Name, LoadTerminal.Name,Products.Measure,Products.MeasureQuantity,
		  UnLoadTerminal.Name,RequestForServices.Status, RequestForServices.Creation, RequestForServices.Id,ServiceLiquidations.RequestForServiceId,
		  LoadCountry.CodeInternational, DischargeCountry.CodeInternational
		ORDER BY RequestForServices.Id desc OFFSET (@PageIndex-1)*@PageSize ROWS FETCH FIRST @PageSize ROWS ONLY
		/*-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
End