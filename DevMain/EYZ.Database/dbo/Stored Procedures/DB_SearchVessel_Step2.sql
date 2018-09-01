-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--[dbo].[DB_SearchVessel_Step2]  @token ='95aae792-36e3-405e-91d0-04fd93f21fac' ,@UpdatedId =33

CREATE PROCEDURE [dbo].[DB_SearchVessel_Step2] 
	-- Add the parameters for the stored procedure here
	  @token uniqueidentifier=null
	 ,@Status varchar(25)='PENDING'
	 ,@Continue bit=0
     ,@UpdatedId int
	 ,@ReCalcule int=0
	 ,@tokenServiceLiquidation uniqueidentifier=null
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
	Declare @ProductId int
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
			,@LoadingRate float
			,@DischargePortId int
			,@DischargeTerminalId int
			,@UnLoadingRate money
			,@StartLaycan datetime
			,@EndLaycan datetime
			--,@Status varchar(250)
			,@IsActive bit
			,@RequestForServiceId int
			,@HourCanalPanama float
	Declare @RateLoadTerminal money,@RateChargeTerminal money,@ServiceLiquidationId int
	Declare @DistanceCurrentPort int, @DistanceLoadPort int, @DistanceUnLoadPort int
	Declare @ValueLoadingCondition int,@HourCanalPanamaDischarge float
	Declare @ValueUnLoadingCondition int
	Declare @VesselFound table (Id int Identity(1,1), VesselId int ,VesselName varchar(250),VesselSpeed float,VesselCapacity int,VesselIfoConsumed money ,VesselMgoConsumed money,IsProcess bit default(0),CurrentPortId int,RateLoading money ,RateUnLoading money,IsCurrentPort bit default(0))
	Declare @Liquidation table (Id int Identity(1,1),Route varchar(150),Type varchar(50),VesselId int, CurrentPortAtLoadPort money ,LoadingPort money,CanalPanama money,LoadPortAtUnloadingPort money,CanalPanamaDischarge money,UnloadingPort money ,IsPrice int default(0),ServiceLiquidationId int,CurrentPortId int, LoadingPortId int, UnLoadingPortId int,IsCurrentPort bit default 1)
	Declare @CurrentId int,@VesselId int ,@VesselName varchar(250),@VesselSpeed float,@VesselCapacity int,@VesselIfoConsumed money ,@VesselMgoConsumed money,@CurrentPortId int
	Declare @CurrentInterval float,@PortsNameLoading varchar(250),@PortsNameUnLoading varchar(250),@RateLoading money, @RateUnLoading money,@CurrentFirstInterval int
	Declare @PortsFirstNameCurrent varchar(250),@PortsFirstNameLoading varchar(250),@IsCurrentPort bit,@PortRateLoading float ,@PortRateUnLoading float
	Declare @DayCurrentPortAtLoadPort float,@DayLoadingPort float,@DayCanalPanama float,@DayLoadPortAtUnloadingPort float,@DayCanalPanamaDischarge float ,@DayUnLoadingPort float
	-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	Begin Try
	--------------------------------------------------------------------------------
	-- Select Record
	--------------------------------------------------------------------------------
	if(@ReCalcule=0)
	Begin
			SELECT @ProductId=ProductId
				  ,@StowageFactorId=StowageFactorId
				  ,@StowageFactor=StowageFactor
				  ,@QuantityId=QuantityId
				  ,@Quantity=Quantity
				  ,@ToleranceId=ToleranceId
				  ,@Terms=Terms
				  ,@LoadingConditionId=LoadingConditionId
				  ,@UnLoadingConditionId=UnLoadingConditionId
				  ,@LoadPortId=LoadPortId
				  ,@LoadTerminalId=LoadTerminalId
				  ,@LoadingRate=LoadingRate
				  ,@DischargePortId=DischargePortId
				  ,@DischargeTerminalId=DischargeTerminalId
				  ,@UnLoadingRate=UnLoadingRate
				  ,@StartLaycan=StartLaycan
				  ,@EndLaycan=EndLaycan
				 -- ,@Status=Status
				  ,@IsActive=IsActive
				  ,@RequestForServiceId=Id
				  ,@HourCanalPanamaDischarge=HourCanalPanama
			FROM dbo.RequestForServices
			Where token=@token
	 

			Select Top 1 @RateLoadTerminal=Rate 
			From RankRateTerminals 
			Where @Quantity between Minimum and Maximum And TerminalId=@LoadTerminalId

			Select Top 1 @RateChargeTerminal=Rate 
			From RankRateTerminals 
			Where @Quantity between Minimum and Maximum And TerminalId=@DischargeTerminalId

			if(@Continue=0)
			Begin
				Delete ItemsLiquidation
				From ItemsLiquidation
					Inner Join  ServiceLiquidations On ServiceLiquidations.Id=ItemsLiquidation.ServiceLiquidationId
				Where RequestForServiceId=@RequestForServiceId	

				Delete from [dbo].[ServiceLiquidations] where RequestForServiceId=@RequestForServiceId
			End
			If Not Exists(Select 1 From ServiceLiquidations Where RequestForServiceId=@RequestForServiceId)
			Begin
				Select Top 1 @ValueLoadingCondition=ConditionValue
				From Terminals
				Where ConditionId=@LoadingConditionId

				if(Isnull(@ValueLoadingCondition,0)=0)
				begin
					Select Top 1 @ValueLoadingCondition=Value
					From Conditions
					Where Id=@LoadingConditionId
				End

				Select Top 1 @ValueUnLoadingCondition=ConditionValue
				From Terminals
				Where ConditionId=@UnLoadingConditionId

				if(Isnull(@ValueUnLoadingCondition,0)=0)
				begin
					Select Top 1 @ValueLoadingCondition=Value
					From Conditions
					Where Id=@LoadingConditionId
				End


				;With CTEAvailability as (
					Select distinct  VesselId,CurrentPortId,(Case When CurrentPortId!=@LoadPortId then 1 else 0 End) as IsCurrentPort
					From AvailableOpenVessels
					Where IsAvailable=1 and IsActive=1
							and @StartLaycan  Between  NextOpeningPort and @EndLaycan
				)
				Insert into @VesselFound(VesselId,VesselName,VesselSpeed,VesselCapacity,VesselIfoConsumed,VesselMgoConsumed,CurrentPortId,RateLoading,RateUnLoading,IsCurrentPort)
				Select  Vessel.Id,Vessel.Name,Vessel.Speed,Vessel.Capacity,Vessel.IfoConsumed,Vessel.MgoConsumed,CTEAvailability.CurrentPortId,RateLoading,RateUnLoading,CTEAvailability.IsCurrentPort
				From [dbo].[Vessel]
					Inner Join ProductByVessels On ProductByVessels.VesselId=Vessel.Id 
					Inner Join CTEAvailability On CTEAvailability.VesselId=Vessel.Id 
				Where ProductByVessels.ProductId=@ProductId and Vessel.Capacity>=@Quantity
						And Vessel.IsActive=1
	
				While(Select Count(1) from @VesselFound Where IsProcess=0)>0
				Begin
					Select Top 1 @CurrentId=Id
					From @VesselFound 
					Where IsProcess=0
					Order By Id asc

					Select @VesselId =VesselId ,
						   @VesselName=VesselName,
						   @VesselSpeed =VesselSpeed,
						   @VesselCapacity =VesselCapacity,
						   @VesselIfoConsumed =VesselIfoConsumed ,
						   @VesselMgoConsumed =VesselMgoConsumed,
						   @CurrentPortId =CurrentPortId,
						   @RateLoading=RateLoading,
						   @RateUnLoading=RateUnLoading,
						   @IsCurrentPort=IsCurrentPort
					From @VesselFound
					Where Id=@CurrentId

					INSERT INTO [dbo].[ServiceLiquidations]
							   ([RequestForServiceId]
							   ,[VesselId]
							   ,[Status]
							   ,[Creation]
							   ,[UpdatedId]
							   ,CurrentPortId)
						 VALUES
							   (@RequestForServiceId
							   ,@VesselId
							   ,'PENDING'
							   ,getdate()
							   ,@UpdatedId
							   ,@CurrentPortId)
					Set @ServiceLiquidationId=SCOPE_IDENTITY()
		
					Declare @IfoLoadPort money,@MgoLoadPort money
					Declare @IfoUnLoadPort money,@MgoUnLoadPort money

						Set @CurrentFirstInterval=0
						Set @HourCanalPanama=0
						Set @PortsFirstNameCurrent=0
						Set @PortsFirstNameLoading=''
						if(@IsCurrentPort=1)
						Begin
							Select @CurrentFirstInterval=Interval 
							From DistanceBetweenPorts 
							Where InputPortId=@CurrentPortId and OutPutPortId=@LoadPortId

					
							Select @HourCanalPanama=HourCanalPanama 
							From DistanceBetweenPorts 
							Where InputPortId=@CurrentPortId and OutPutPortId=@LoadPortId

							Select @PortsFirstNameCurrent=Ports.Name
							From Ports 
							Where Ports.Id=@CurrentPortId

							Select @PortsFirstNameLoading=Ports.Name
							From Ports 
							Where Ports.Id=@LoadPortId
						End

						Select @CurrentInterval=Interval 
						From DistanceBetweenPorts 
						Where InputPortId=@LoadPortId and OutPutPortId=@DischargePortId
		
						Select Top 1 @PortsNameLoading=Ports.Name,@IfoLoadPort=Ifo, @MgoLoadPort=Mgo
						From Ports 
						Where Ports.Id=@LoadPortId

						Select  Top 1  @PortsNameUnLoading=Ports.Name,@IfoUnLoadPort=Ifo, @MgoUnLoadPort=Mgo
						From Ports 
						Where Ports.Id=@DischargePortId

						Set @DayCurrentPortAtLoadPort=(@CurrentFirstInterval/@VesselSpeed)/24
						Set @DayLoadingPort=(@Quantity/@LoadingRate)
						Set @DayCanalPanama=(Case When @HourCanalPanama>0 Then @HourCanalPanama/24 else 0 End)
						Set @DayLoadPortAtUnloadingPort=(@CurrentInterval/@VesselSpeed)/24
						Set @DayCanalPanamaDischarge=(Case When @HourCanalPanamaDischarge>0 Then @HourCanalPanamaDischarge/24 else 0 End)
						Set @DayUnLoadingPort=  (@Quantity/@UnLoadingRate)

						Insert into @Liquidation([Route],Type,VesselId,CurrentPortAtLoadPort,LoadingPort,CanalPanama,LoadPortAtUnloadingPort,CanalPanamaDischarge,UnLoadingPort,IsPrice,ServiceLiquidationId,CurrentPortId  , LoadingPortId  , UnLoadingPortId ,IsCurrentPort)
						Select '01-DISTANCE (nm)' As 'Route',	'TOTAL',	@VesselId as 'VesselId ',		Isnull(@CurrentFirstInterval,0)  as 'CurrentPortAtLoadPort', 0 as 'LoadingPort',   0 as 'CanalPanama', @CurrentInterval as 'LoadPortAtUnloadingPort',0 as 'CanalPanamaDischarge' ,0 as 'UnLoadingPort ', 0 as IsPrice,@ServiceLiquidationId,@CurrentPortId  , @LoadPortId  , @DischargePortId ,@IsCurrentPort 
						Union All
						Select '02-SPEED (knots)' As 'Route',	'',	@VesselId as 'VesselId ',		(Case When @CurrentFirstInterval>0 then Isnull(@VesselSpeed,0) else 0 end)  as 'CurrentPortAtLoadPort' , 0 as 'LoadingPort', 0 as 'CanalPanama', @VesselSpeed as 'LoadPortAtUnloadingPort',0 as 'CanalPanamaDischarge'  ,0 as 'UnLoadingPort ', 0 as IsPrice,@ServiceLiquidationId,@CurrentPortId  , @LoadPortId  , @DischargePortId  ,@IsCurrentPort
						Union All
						Select '03-HOURS'		  As 'Route',   'TOTAL',		@VesselId as 'VesselId ',	(Case When @CurrentFirstInterval>0 then (@CurrentFirstInterval/@VesselSpeed)  else 0 end)	  as 'CurrentPortAtLoadPort' ,((@Quantity/@LoadingRate)*24)*@ValueLoadingCondition as 'LoadingPort', @HourCanalPanama as 'CanalPanama', (@CurrentInterval/@VesselSpeed) as 'LoadPortAtUnloadingPort',@HourCanalPanamaDischarge as 'CanalPanamaDischarge',((@Quantity/@UnLoadingRate)*24)*@ValueUnLoadingCondition  as 'UnLoadingPort ', 0 as IsPrice,@ServiceLiquidationId,@CurrentPortId  , @LoadPortId  , @DischargePortId  ,@IsCurrentPort
						Union All
						Select '04-DAILY HIRE (USD)' As 'Route','',	@VesselId as 'VesselId ',		@RateLoading  as 'CurrentPortAtLoadPort' ,@RateLoading as 'LoadingPort', (Case When @HourCanalPanama>0 then @RateLoading else 0 end) as 'CanalPanama', @RateUnLoading as 'LoadPortAtUnloadingPort',(Case When @HourCanalPanamaDischarge>0 then @RateUnLoading else 0 end)  as 'CanalPanamaDischarge' ,@RateUnLoading as 'UnLoadingPort',2 as IsPrice,@ServiceLiquidationId,@CurrentPortId  , @LoadPortId  , @DischargePortId  ,@IsCurrentPort
						Union All
						Select '05-PRORATED DAILY HIRE PER ROUTE' As 'Route','TOTAL', @VesselId as 'VesselId ',		(@DayCurrentPortAtLoadPort*@RateLoading)  as 'CurrentPortAtLoadPort' ,(@DayLoadingPort*@RateLoading) as 'LoadingPort', (Case When @HourCanalPanama >0 Then (@DayCanalPanama*@RateLoading) else 0 End)  as 'CanalPanama', (@DayLoadPortAtUnloadingPort*@RateUnLoading) as 'LoadPortAtUnloadingPort',(Case When @HourCanalPanamaDischarge>0 then   (@DayCanalPanamaDischarge*@RateLoading)  else 0 end )as 'CanalPanamaDischarge' ,(@DayUnLoadingPort*@RateUnLoading) as 'UnLoadingPort',1 as IsPrice,@ServiceLiquidationId,@CurrentPortId  , @LoadPortId  , @DischargePortId  ,@IsCurrentPort
						Union All
						Select '06-IFO CONSUMED PER ROUTE  (using '+ convert(varchar,@VesselIfoConsumed) +'  MT/day)' As 'Route',	'TOTAL',	@VesselId as 'VesselId ',		(@DayCurrentPortAtLoadPort*@VesselIfoConsumed) as 'CurrentPortAtLoadPort'	, 0 as 'LoadingPort', (Case When @HourCanalPanama >0 Then (@DayCanalPanama*@VesselIfoConsumed) else 0 End) as 'CanalPanama', (@DayLoadPortAtUnloadingPort*@VesselIfoConsumed) as 'LoadPortAtUnloadingPort',(Case When @HourCanalPanamaDischarge >0 Then (@DayCanalPanamaDischarge*@VesselIfoConsumed) else 0 End) as 'CanalPanamaDischarge' , 0 as 'UnLoadingPort',0 as IsPrice,@ServiceLiquidationId,@CurrentPortId  , @LoadPortId  , @DischargePortId  ,@IsCurrentPort
						Union All
						Select '07-IFO COST IN LOAD PORT (USD per MT)' As 'Route','',@VesselId as 'VesselId ',	(Case When @CurrentFirstInterval>0 then @IfoLoadPort else 0 end) as 'CurrentPortAtLoadPort'	, 0 as 'LoadingPort',(Case When @HourCanalPanama >0 Then @IfoLoadPort else 0 End) as 'CanalPanama', @IfoLoadPort as 'LoadPortAtUnloadingPort',(Case When @HourCanalPanamaDischarge >0 Then @IfoLoadPort else 0 End) as 'CanalPanamaDischarge', 0 as 'UnLoadingPort',2 as IsPrice,@ServiceLiquidationId,@CurrentPortId  , @LoadPortId  , @DischargePortId  ,@IsCurrentPort
						Union All
						Select '08-IFO CONSUMED (USD)' As 'Route','TOTAL',		@VesselId as 'VesselId ',		(@DayCurrentPortAtLoadPort*@VesselIfoConsumed)*@IfoLoadPort  as 'CurrentPortAtLoadPort'	, 0 as 'LoadingPort', (@DayCanalPanama*@VesselIfoConsumed)*@IfoLoadPort as 'CanalPanama', (@DayLoadPortAtUnloadingPort*@VesselIfoConsumed)*@IfoLoadPort as 'LoadPortAtUnloadingPort',(@DayCanalPanamaDischarge*@VesselIfoConsumed)*@IfoLoadPort as 'CanalPanamaDischarge' , 0 as 'UnLoadingPort',1 as IsPrice,@ServiceLiquidationId,@CurrentPortId  , @LoadPortId  , @DischargePortId  ,@IsCurrentPort
						Union All
						Select '09-MGO CONSUMED PER ROUTE (using '+ convert(varchar,@VesselMgoConsumed) +'  MT/day) ' As 'Route',	'TOTAL',		@VesselId as 'VesselId ',		0  as 'CurrentPortAtLoadPort'	, (@Quantity/@LoadingRate)*@VesselMgoConsumed as 'LoadingPort', 0 as 'CanalPanama', 0 as 'LoadPortAtUnloadingPort',0 as 'CanalPanamaDischarge' ,(@Quantity/@UnLoadingRate)*@VesselMgoConsumed as 'UnLoadingPort',0 as IsPrice,@ServiceLiquidationId,@CurrentPortId  , @LoadPortId  , @DischargePortId  ,@IsCurrentPort
						Union All
						Select '10-MGO COST IN LOAD PORT (USD per MT)' As 'Route','',@VesselId as 'VesselId ',(Case When @CurrentFirstInterval>0 then	@MgoLoadPort else 0 end)  as 'CurrentPortAtLoadPort'	,@MgoLoadPort as 'LoadingPort', 0 as 'CanalPanama',  @MgoLoadPort as 'LoadPortAtUnloadingPort',0 as 'CanalPanamaDischarge' , @MgoLoadPort as 'UnLoadingPort',2 as IsPrice,@ServiceLiquidationId,@CurrentPortId  , @LoadPortId  , @DischargePortId  ,@IsCurrentPort
						Union All
						Select '11-MGO CONSUMED (USD)' As 'Route',	'TOTAL',	@VesselId as 'VesselId ',		0  as 'CurrentPortAtLoadPort'	,((@Quantity/@LoadingRate)*@VesselMgoConsumed)*@MgoLoadPort as 'LoadingPort', 0 as 'CanalPanama', 0 as 'LoadPortAtUnloadingPort',0 as 'CanalPanamaDischarge' , ((@Quantity/@UnLoadingRate)*@VesselMgoConsumed)*@MgoLoadPort as 'UnLoadingPort',1 as IsPrice,@ServiceLiquidationId,@CurrentPortId  , @LoadPortId  , @DischargePortId  ,@IsCurrentPort
						Union all
						Select '12-Port Costs in Load/Discharge Port (USD)' As 'Route','TOTAL',@VesselId as 'VesselId ', 0  as 'CurrentPortAtLoadPort'	,@RateLoadTerminal as 'LoadingPort', 0 as 'CanalPanama', 0 as 'LoadPortAtUnloadingPort',0 as 'CanalPanamaDischarge' , @RateChargeTerminal as 'UnLoadingPort',1 as IsPrice,@ServiceLiquidationId,@CurrentPortId  , @LoadPortId  , @DischargePortId  ,@IsCurrentPort
					Update @VesselFound
					set IsProcess=1
					Where Id=@CurrentId
				End
				INSERT INTO [dbo].[ItemsLiquidation]
				   ([ServiceLiquidationId]
				   ,[Route]
				   ,[Type]
				   ,[VesselId]
				   ,[CurrentPortAtLoadPort]
				   ,[LoadingPort]
				   ,[CanalPanama]
				   ,[LoadPortAtUnloadingPort]
				   ,CanalPanamaDischarge
				   ,[UnLoadPort]
				   ,[IsPrice]
				   ,[Creation]
				   ,[UpdatedId],CurrentPortId  , LoadingPortId  , UnLoadingPortId,IsCurrentPort,
				    ValueLoadingCondition,ValueUnLoadingCondition,VesselSpeed,VesselCapacity,VesselIfoConsumed,VesselMgoConsumed,RateLoading,RateUnLoading,CurrentFirstInterval,
					HourCanalPanama,CurrentInterval,DayCurrentPortAtLoadPort,Quantity,LoadingRate,DayLoadingPort,DayLoadPortAtUnloadingPort,DayCanalPanamaDischarge,DayUnLoadingPort,
					IfoLoadPort,MgoLoadPort,IfoUnLoadPort,MgoUnLoadPort,RateLoadTerminal,RateChargeTerminal,UnLoadingRate)
				Select ServiceLiquidationId,[Route],Type,VesselId,CurrentPortAtLoadPort,LoadingPort,CanalPanama,
					   LoadPortAtUnloadingPort,CanalPanamaDischarge,UnLoadingPort,IsPrice,getdate(),@UpdatedId,CurrentPortId  , LoadingPortId  , UnLoadingPortId,IsCurrentPort,
					   @ValueLoadingCondition,@ValueUnLoadingCondition,@VesselSpeed,@VesselCapacity,@VesselIfoConsumed,@VesselMgoConsumed,@RateLoading,@RateUnLoading,@CurrentFirstInterval,
					   @HourCanalPanama,@CurrentInterval,@DayCurrentPortAtLoadPort,@Quantity,@LoadingRate,@DayLoadingPort,@DayLoadPortAtUnloadingPort,@DayCanalPanamaDischarge,@DayUnLoadingPort,
					   @IfoLoadPort,@MgoLoadPort,@IfoUnLoadPort,@MgoUnLoadPort,@RateLoadTerminal,@RateChargeTerminal,@UnLoadingRate
				From @Liquidation 
			End
			;With CTEResult as(
				Select ServiceLiquidations.Token,'TBN' as 'Vessel', StartLaycan , EndLaycan,Vessel.Id as VesselId,ServiceLiquidations.Id, dbo.GetTotalVessel(Vessel.Id,ServiceLiquidations.Id) as Total,Vessel.Name, 
						dbo.GetTotalVessel(Vessel.Id,ServiceLiquidations.Id)/@Quantity as TotalQuantityMT,
						Vessel.Demurrage,ServiceLiquidations.Status,dbo.GetTotalDayVessel(Vessel.Id,ServiceLiquidations.Id)/24 as TotalDay,
						Vessel.Token as  VesselToken
				From RequestForServices
						Inner Join ServiceLiquidations On ServiceLiquidations.RequestForServiceId=RequestForServices.Id
						Inner Join dbo.Vessel On Vessel.Id=ServiceLiquidations.VesselId and Vessel.IsActive=1
						Inner Join dbo.Products On Products.Id=@ProductId and Vessel.IsActive=1
				where RequestForServices.token=@token
			)
			Select * from CTEResult
			Order by TotalQuantityMT asc
	End
	Else
	BEgin
		Update [dbo].[ItemsLiquidation]
		Set LoadingPort=((Quantity/LoadingRate)*24)*ValueLoadingCondition,
		    UnLoadPort=((Quantity/UnLoadingRate)*24)*ValueUnLoadingCondition,
			DayLoadingPort=(Quantity/LoadingRate),
			DayUnLoadingPort=  (Quantity/UnLoadingRate)
		From ItemsLiquidation
				Inner Join ServiceLiquidations On ServiceLiquidations.Id=ItemsLiquidation.ServiceLiquidationId
		Where LEFT(route,2)='03' and ServiceLiquidations.Token=@tokenServiceLiquidation

		Update [dbo].[ItemsLiquidation]
		Set CurrentPortAtLoadPort=(DayCurrentPortAtLoadPort*RateLoading),
		    LoadingPort=(DayLoadingPort*RateLoading),
			CanalPanama=(Case When HourCanalPanama >0 Then (DayCanalPanama*RateLoading) else 0 End),
			LoadPortAtUnloadingPort=  (DayLoadPortAtUnloadingPort*RateUnLoading),
			CanalPanamaDischarge= (Case When CanalPanamaDischarge>0 then   (DayCanalPanamaDischarge*RateLoading)  else 0 end ),
			UnLoadPort=(DayUnLoadingPort*RateUnLoading)
		From ItemsLiquidation
				Inner Join ServiceLiquidations On ServiceLiquidations.Id=ItemsLiquidation.ServiceLiquidationId
		Where LEFT(route,2)='05' and ServiceLiquidations.Token=@tokenServiceLiquidation


		Update [dbo].[ItemsLiquidation]
		Set CurrentPortAtLoadPort=RateLoading,
		    LoadingPort=RateLoading,
			CanalPanama=(Case When HourCanalPanama>0 then RateLoading else 0 end),
			LoadPortAtUnloadingPort=RateUnLoading,
			CanalPanamaDischarge=(Case When CanalPanamaDischarge>0 then RateUnLoading else 0 end),
			UnLoadPort=RateUnLoading
		From ItemsLiquidation
				Inner Join ServiceLiquidations On ServiceLiquidations.Id=ItemsLiquidation.ServiceLiquidationId
		Where LEFT(route,2)='04' and ServiceLiquidations.Token=@tokenServiceLiquidation

		Update [dbo].[ItemsLiquidation]
		Set CurrentPortAtLoadPort=(Case When CurrentFirstInterval>0 then IfoLoadPort else 0 end),
		    CanalPanama=(Case When HourCanalPanama >0 Then IfoLoadPort else 0 End),
			LoadPortAtUnloadingPort=IfoLoadPort,
			CanalPanamaDischarge=  (Case When CanalPanamaDischarge >0 Then IfoLoadPort else 0 End)
		From ItemsLiquidation
				Inner Join ServiceLiquidations On ServiceLiquidations.Id=ItemsLiquidation.ServiceLiquidationId
		Where LEFT(route,2)='07' and ServiceLiquidations.Token=@tokenServiceLiquidation

		Update [dbo].[ItemsLiquidation]
		Set CurrentPortAtLoadPort=(DayCurrentPortAtLoadPort*VesselIfoConsumed)*IfoLoadPort,
		    CanalPanama=(DayCanalPanama*VesselIfoConsumed)*IfoLoadPort,
			LoadPortAtUnloadingPort=(DayLoadPortAtUnloadingPort*VesselIfoConsumed)*IfoLoadPort,
			CanalPanamaDischarge= (DayCanalPanamaDischarge*VesselIfoConsumed)*IfoLoadPort
		From ItemsLiquidation
				Inner Join ServiceLiquidations On ServiceLiquidations.Id=ItemsLiquidation.ServiceLiquidationId
		Where LEFT(route,2)='08' and ServiceLiquidations.Token=@tokenServiceLiquidation

		Update [dbo].[ItemsLiquidation]
		Set LoadingPort=(Quantity/LoadingRate)*VesselMgoConsumed,
		    UnLoadPort=(Quantity/UnLoadingRate)*VesselMgoConsumed
		From ItemsLiquidation
				Inner Join ServiceLiquidations On ServiceLiquidations.Id=ItemsLiquidation.ServiceLiquidationId
		Where LEFT(route,2)='09' and ServiceLiquidations.Token=@tokenServiceLiquidation

		Update [dbo].[ItemsLiquidation]
		Set LoadingPort=(Quantity/LoadingRate)*VesselMgoConsumed,
		    UnLoadPort=(Quantity/UnLoadingRate)*VesselMgoConsumed
		From ItemsLiquidation
				Inner Join ServiceLiquidations On ServiceLiquidations.Id=ItemsLiquidation.ServiceLiquidationId
		Where LEFT(route,2)='09' and ServiceLiquidations.Token=@tokenServiceLiquidation

		Update [dbo].[ItemsLiquidation]
		Set CurrentPortAtLoadPort=(Case When CurrentFirstInterval>0 then	MgoLoadPort else 0 end),
		    LoadingPort=MgoLoadPort,
		    LoadPortAtUnloadingPort=MgoLoadPort,
		    UnLoadPort=MgoLoadPort
		From ItemsLiquidation
				Inner Join ServiceLiquidations On ServiceLiquidations.Id=ItemsLiquidation.ServiceLiquidationId
		Where LEFT(route,2)='10' and ServiceLiquidations.Token=@tokenServiceLiquidation

		Update [dbo].[ItemsLiquidation]
		Set LoadingPort=((Quantity/LoadingRate)*VesselMgoConsumed)*MgoLoadPort,
		    UnLoadPort=((Quantity/UnLoadingRate)*VesselMgoConsumed)*MgoLoadPort
		From ItemsLiquidation
				Inner Join ServiceLiquidations On ServiceLiquidations.Id=ItemsLiquidation.ServiceLiquidationId
		Where LEFT(route,2)='11' and ServiceLiquidations.Token=@tokenServiceLiquidation

	End
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
END