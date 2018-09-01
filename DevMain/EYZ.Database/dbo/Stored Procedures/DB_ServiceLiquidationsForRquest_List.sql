CREATE PROCEDURE [dbo].[DB_ServiceLiquidationsForRquest_List]
	@PageIndex [int] = 1,
	@PageSize [int] = 10,
	@TotalRecords [int] = 0 OUTPUT,
	@Token uniqueidentifier,
	@UpdatedId int
AS
Begin


	/*------------------------------------------------------------------------------
		-- getting xml main list only range: records_[begin,end], setting record status.
		--------------------------------------------------------------------------------*/
		Declare @RequestForServiceId int
		Select @RequestForServiceId= Id From RequestForServices Where Token=@Token
		Select @TotalRecords=count(*) From ServiceLiquidations
									Inner Join Vessel On Vessel.Id=ServiceLiquidations.VesselId
									Inner Join RequestForServices On RequestForServices.Id=ServiceLiquidations.RequestForServiceId
		Where RequestForServiceId=@RequestForServiceId and ServiceLiquidations.IsActive=1
		------------------------------------------------------------------------------
		-- getting user list
		------------------------------------------------------------------------------	
		Select ServiceLiquidations.Token, @Token as TokenKey, RequestForServices.Id,
				(Case When [dbo].[GetProfile](@UpdatedId)='CUSTOMERS' Then 'TBN' else  Vessel.Name End) as Vessel , ServiceLiquidations.Status, ServiceLiquidations.Creation,
				RequestForServices.StartLaycan, RequestForServices.EndLaycan,Vessel.Demurrage,
				dbo.GetTotalVessel(Vessel.Id,ServiceLiquidations.Id)/Quantity as  TotalQuantityMT,
				dbo.GetTotalDayVessel(Vessel.Id,ServiceLiquidations.Id)/24 as TotalDay,Vessel.Token as VesselToken, Isnull(ServiceLiquidations.PriceMT,0) as PriceMT
				,Isnull(ServiceLiquidations.PriceMTNew,0) as PriceMTNew
		From ServiceLiquidations
			Inner Join Vessel On Vessel.Id=ServiceLiquidations.VesselId
			Inner Join RequestForServices On RequestForServices.Id=ServiceLiquidations.RequestForServiceId
		Where RequestForServiceId=@RequestForServiceId and ServiceLiquidations.IsActive=1 and ServiceLiquidations.Status!='PENDING'
		ORDER BY CURRENT_TIMESTAMP OFFSET (@PageIndex-1)*@PageSize ROWS FETCH FIRST @PageSize ROWS ONLY
		/*-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
End