CREATE PROCEDURE [dbo].[DB_UpdateRequestForThisVessel]
	  @Token uniqueidentifier=null
     ,@UpdatedId int=0
	 ,@Run bit=0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--------------------------------------------------------------------------------
	-- IMPORTANT: Set this option ON: if do you wants stop and rollback transaction.
	--------------------------------------------------------------------------------
	SET XACT_ABORT ON
	SET NOCOUNT ON;
	Declare @RequestToken uniqueidentifier, @ServiceLiquidationToken uniqueidentifier, @Id int,@Count int
	Declare @TokeRecalculate table(Id int, RequestToken uniqueidentifier, ServiceLiquidationToken uniqueidentifier)
	Declare @sError varchar(max) ,@IsErrorTecnichal int
	Execute C_Parameter_Get @CodeParameter= 'ERROR_TECNICHAL', @Value= @IsErrorTecnichal OUTPUT
	Begin Try
	if(@Run=0)
	Begin
		;With CTERecalculate as (
			Select RequestForServices.Token as RequestToken,ServiceLiquidations.Token as TokenServiceLiquidation,ROW_NUMBER() OVER(ORDER BY RequestForServices.Id ASC) AS Id
			From RequestForServices
					Inner join ServiceLiquidations On RequestForServices.Id=ServiceLiquidations.RequestForServiceId and ServiceLiquidations.Status='REQUEST'
					Inner Join Vessel On Vessel.Id=ServiceLiquidations.VesselId
			Where Vessel.Token=@Token
		)
		Insert into SchedulerRequestByVesselForRecalculate(IdAutomatic, RequestToken, ServiceLiquidationToken)
		Select Id, RequestToken, TokenServiceLiquidation 
		From CTERecalculate
		
	End
	Else
	Begin
		Begin Transaction
			Select @Count=Max(Id) 
			From @TokeRecalculate
			Set @Id=1

			While(@Count>@Id)
			Begin
				Select @RequestToken=RequestToken,
					   @ServiceLiquidationToken=ServiceLiquidationToken
				From @TokeRecalculate
				Where Id=@Id
				
				Exec [dbo].[DB_SearchVessel_Step2]  @token =@RequestToken ,@UpdatedId =@UpdatedId
				Exec DB_SearchVessel_Continue @RequestToken,@ServiceLiquidationToken,@UpdatedId

				Set @Id=@Id+1
			End
		Commit Transaction
	End
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