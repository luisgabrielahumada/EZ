CREATE PROCEDURE [dbo].[DB_RequesForServices_List]
	@PageIndex [int] = 1,
	@PageSize [int] = 10,
	@TotalRecords [int] = 0 OUTPUT,
	@Owner int,
	@UpdatedId int,
	@ProductId int=0, 
	@StowageFactorId int=0, 
    @QuantityId int=0, 
	@LoadingConditionId int=0,  
	@UnLoadingConditionId int=0,  
	@LoadPortId int=0,  
	@LoadTerminalId int=0, 
	@DischargePortId int=0, 
	@DischargeTerminalId int=0, 
	@StartLaycan date=null,
	@EndLaycan date=null
AS
Begin


	/*------------------------------------------------------------------------------
		-- getting xml main list only range: records_[begin,end], setting record status.
		--------------------------------------------------------------------------------*/
		Select @TotalRecords=count(*) From RequestForServices Where Owner=@Owner
		------------------------------------------------------------------------------
		-- getting user list
		------------------------------------------------------------------------------						   
		Select RequestForServices.Token, Products.Name as Product, StowageFactors.Name as StowageFactors, RequestForServices.StowageFactor, RequestForServices.Quantity ,QuantityMT.Name as Quantitys,
		 LoadingCondition.Name as LoadingConditionName,UnLoadingCondition.Name as UnLoadingConditionName, RequestForServices.LoadingRate,RequestForServices.UnLoadingRate,RequestForServices.StartLaycan,RequestForServices.EndLaycan,
		  RequestForServices.Terms,Tolerance.Name as Tolerance, LoadPort.Name as LoadPort, UnLoadPort.Name as UnLoadPort, LoadTerminal.Name as LoadTerminal,
		  UnLoadTerminal.Name as UnLoadTerminal
		From RequestForServices
			Inner Join Products On Products.Id=RequestForServices.ProductId
			Left Join StowageFactors On StowageFactors.Id=RequestForServices.StowageFactorId
			Left Join QuantityMT On QuantityMT.Id=RequestForServices.QuantityId
			Inner Join Conditions as LoadingCondition On LoadingCondition.Id=RequestForServices.LoadingConditionId
			Inner Join Conditions as UnLoadingCondition On UnLoadingCondition.Id=RequestForServices.UnLoadingConditionId
			Inner Join Tolerance On Tolerance.Id=RequestForServices.ToleranceId
			Inner Join Ports as LoadPort On LoadPort.Id=RequestForServices.LoadPortId
			Inner Join Ports as UnLoadPort On UnLoadPort.Id=RequestForServices.DischargePortId
			Inner Join Terminals as LoadTerminal On LoadTerminal.Id=RequestForServices.LoadTerminalId
			Inner Join Terminals as UnLoadTerminal On UnLoadTerminal.Id=RequestForServices.DischargeTerminalId
		Where 
			(Products.Id=@ProductId or @ProductId=0) 
			And (StowageFactors.Id=@StowageFactorId or @StowageFactorId=0) 
			And (QuantityMT.Id=@QuantityId or @QuantityId=0) 
			And (LoadingCondition.Id=@LoadingConditionId or @LoadingConditionId=0) 
			And (UnLoadingCondition.Id=@UnLoadingConditionId or @UnLoadingConditionId=0) 
			And (LoadPort.Id=@LoadPortId or @LoadPortId=0) 
			And (LoadTerminal.Id=@LoadTerminalId or @LoadTerminalId=0) 
			And (UnLoadPort.Id=@DischargePortId or @DischargePortId=0) 
			And (UnLoadTerminal.Id=@DischargeTerminalId or @DischargeTerminalId=0) 
			And (RequestForServices.StartLaycan>=@StartLaycan or @StartLaycan='0001-01-01') 
			And (RequestForServices.EndLaycan<=@EndLaycan or @EndLaycan='0001-01-01') 
		--	And Owner=@Owner
		ORDER BY CURRENT_TIMESTAMP OFFSET (@PageIndex-1)*@PageSize ROWS FETCH FIRST @PageSize ROWS ONLY
		/*-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
End