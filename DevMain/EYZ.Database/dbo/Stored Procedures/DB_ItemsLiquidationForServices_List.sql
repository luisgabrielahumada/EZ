-- DB_ItemsLiquidationForServices_List '0986841B-C977-4317-8F98-81B392298AE3',51
CREATE PROCEDURE [dbo].[DB_ItemsLiquidationForServices_List]
	@Token uniqueidentifier,
	@UpdatedId int
AS
Begin


	/*------------------------------------------------------------------------------
		-- getting xml main list only range: records_[begin,end], setting record status.
		--------------------------------------------------------------------------------*/
		Declare @ServiceLiquidationId int,@Price money,@Quantity int,@Total money,@PriceMTNew money,@PriceMT money
		Declare @TotalCurrentPort money,@TotalLoadingPort money,@TotalCanalPanama money,@TotalCanalPanamaDischarge money,@TotalLoadPortAtUnloadingPort money,@TotalUnLoadPort money
		Declare @CurrentPortName varchar(250),@LoadingPortName varchar(250),@UnLoadPortName varchar(250)
		Select @ServiceLiquidationId= Id From ServiceLiquidations Where Token=@Token
		------------------------------------------------------------------------------
		-- getting user list
		------------------------------------------------------------------------------	
		
		Select Top 1  @Quantity=Quantity 
		From ServiceLiquidations
				 Inner Join RequestForServices On RequestForServices.Id=ServiceLiquidations.RequestForServiceId
		Where ServiceLiquidations.Token=@Token

		Select @Price=dbo.GetTotalVessel(ServiceLiquidations.VesselId,ServiceLiquidations.Id)/@Quantity
			  ,@PriceMTNew=PriceMTNew
			  ,@PriceMT=PriceMT
	          ,@Total=dbo.GetTotalVessel(ServiceLiquidations.VesselId,ServiceLiquidations.Id)
	          ,@TotalCurrentPort=dbo.GetTotalCurrentPort(ServiceLiquidations.VesselId,ServiceLiquidations.Id)
	          ,@TotalLoadingPort=dbo.GetTotalLoadingPort(ServiceLiquidations.VesselId,ServiceLiquidations.Id)
	          ,@TotalCanalPanama=dbo.GetTotalCanalPanama(ServiceLiquidations.VesselId,ServiceLiquidations.Id)
	          ,@TotalCanalPanamaDischarge=dbo.GetTotalCanalPanamaDischarge(ServiceLiquidations.VesselId,ServiceLiquidations.Id)
	          ,@TotalLoadPortAtUnloadingPort=dbo.GetTotalLoadPortAtUnloadingPort(ServiceLiquidations.VesselId,ServiceLiquidations.Id)
	          ,@TotalUnLoadPort=dbo.GetTotalUnLoadPort(ServiceLiquidations.VesselId,ServiceLiquidations.Id)
		From ServiceLiquidations 
		Where Token=@Token				
			   
		SELECT ItemsLiquidation.Route
			  ,Vessel.Token as VesselToken
			  ,Isnull(ItemsLiquidation.CurrentPortAtLoadPort,0) as CurrentPortAtLoadPort
			  ,ItemsLiquidation.LoadingPort
			  ,CanalPanama
			  ,ItemsLiquidation.LoadPortAtUnloadingPort
			  ,CanalPanamaDischarge 
			  ,ItemsLiquidation.UnLoadPort
			  ,ItemsLiquidation.IsPrice
			  ,ItemsLiquidation.Creation
			  ,ItemsLiquidation.Updated
			  ,ItemsLiquidation.IsActive
			  ,ItemsLiquidation.UpdatedId
			  ,Isnull(ItemsLiquidation.CurrentPortAtLoadPort,0)+ItemsLiquidation.LoadingPort+CanalPanama+ItemsLiquidation.LoadPortAtUnloadingPort+ItemsLiquidation.CanalPanamaDischarge+ItemsLiquidation.UnLoadPort as ItemTotal
			  ,ItemsLiquidation.Type
			  ,@Price as Price
			  ,Isnull(@PriceMT,@Price) as PriceMT 
			  ,Isnull(@PriceMTNew,@Price) as PriceMTNew 
			  ,@Quantity as Quantity
			  ,@Total as Total
			  ,@TotalCurrentPort as TotalCurrentPort
			  ,@TotalLoadingPort as TotalLoadingPort
			  ,@TotalCanalPanama as TotalCanalPanama
			  ,@TotalCanalPanamaDischarge as TotalCanalPanamaDischarge
			  ,@TotalLoadPortAtUnloadingPort as TotalLoadPortAtUnloadingPort
			  ,@TotalUnLoadPort as TotalUnLoadPort
			  ,RequestForServices.Token AS TokenParent
			  ,ServiceLiquidations.Status as ServiceStatus
			  , @TotalCurrentPort+@TotalLoadingPort+@TotalCanalPanama+@TotalLoadPortAtUnloadingPort+@TotalCanalPanamaDischarge+@TotalUnLoadPort as SumTotal,
			  IsCurrentPort,ItemsLiquidation.Token as TokenLiquidation
		FROM [dbo].[ItemsLiquidation]
			Inner Join ServiceLiquidations On ServiceLiquidations.Id=ItemsLiquidation.ServiceLiquidationId
			Inner Join Vessel On Vessel.Id=ItemsLiquidation.VesselId
			Inner Join RequestForServices On RequestForServices.Id=ServiceLiquidations.RequestForServiceId
		Where ServiceLiquidationId=@ServiceLiquidationId
		/*-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
End