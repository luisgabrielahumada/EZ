-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

--DB_SearchVessel_Continue 'cd10b7e1-79bc-461b-9e54-b163eee49b62','b3a14d45-54a1-4321-8029-2c783fdc7824,1353a80d-bfa7-486a-810d-e98ecb5bea0b',51
CREATE PROCEDURE [dbo].[DB_SearchVessel_Continue]
	  @RequestToken uniqueidentifier
	 ,@token varchar(max)
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

		Update ServiceLiquidations
		Set Status='PENDING',
			 Updated=getdate()
		From ServiceLiquidations
			Inner Join RequestForServices On RequestForServices.Id=ServiceLiquidations.RequestForServiceId
		Where RequestForServices.Token=@RequestToken
		
	
		 Update ServiceLiquidations
		 Set Status='REQUEST',
			 Updated=getdate()
		 From ServiceLiquidations
			 Inner Join [dbo].[TableSplit](@token,',') as T On ServiceLiquidations.Token=T.Item
	Commit Transaction
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

	 
	 Select Distinct Vessel.Owner,RequestForServices.Id
			,Products.Name as ProductName
			,LoadTerminal.Name as LoadTerminalName
			,DischargeTerminal.Name as DischargeTerminalName
			,QuantityMT.Name as QuantityMTName,
			RequestForServices.StartLaycan,RequestForServices.EndLaycan,dbo.GetStatusRequest(RequestForServices.Id)  as NewStatus
	 From ServiceLiquidations
		 Inner join RequestForServices On RequestForServices.Id=ServiceLiquidations.RequestForServiceId --and ServiceLiquidations.Status='INPROGRESS'
		 Inner join ItemsLiquidation On ItemsLiquidation.ServiceLiquidationId=ServiceLiquidations.Id
		 Inner join Vessel On Vessel.Id=ItemsLiquidation.VesselId
		 Inner join Products On Products.Id=RequestForServices.ProductId
		 Left join QuantityMT On QuantityMT.Id=RequestForServices.QuantityId
		Left join QuantityMTByProducts On QuantityMTByProducts.ProductId=RequestForServices.ProductId and QuantityMTByProducts.QuantityMTId= QuantityMT.Id
		Inner join Ports as LoadPort On LoadPort.Id=RequestForServices.LoadPortId
		Inner join Ports as DischargePort On DischargePort.Id=RequestForServices.DischargePortId
		Inner Join TerminalByProducts as TerminalByProductLoad On TerminalByProductLoad.ProductId=RequestForServices.ProductId
		Inner join Terminals as LoadTerminal On LoadTerminal.Id=RequestForServices.LoadTerminalId and TerminalByProductLoad.TerminalId=LoadTerminal.Id
		Inner Join TerminalByProducts as TerminalByProductDischarge On TerminalByProductDischarge.ProductId=RequestForServices.ProductId
		Inner join Terminals as DischargeTerminal On DischargeTerminal.Id=RequestForServices.DischargeTerminalId and TerminalByProductDischarge.TerminalId=DischargeTerminal.Id
	 Where RequestForServices.Token=@RequestToken 
END