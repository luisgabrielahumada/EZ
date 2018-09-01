-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
 
CREATE PROCEDURE [dbo].[DB_ChangeStatusRequestVessel_Save]
	-- Add the parameters for the stored procedure here
	  @Token varchar(max)
	 ,@Status varchar(25)
	 ,@PriceMT money
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
	Declare @sError varchar(max) ,@IsErrorTecnichal int,@Quantity int, @Price money
	Execute C_Parameter_Get @CodeParameter= 'ERROR_TECNICHAL', @Value= @IsErrorTecnichal OUTPUT
	Begin Try
	Begin Transaction


		Select Top 1  @Quantity=Quantity 
		From ServiceLiquidations
				 Inner Join RequestForServices On RequestForServices.Id=ServiceLiquidations.RequestForServiceId
		Where ServiceLiquidations.Token=@Token

		Select @Price=dbo.GetTotalVessel(ServiceLiquidations.VesselId,ServiceLiquidations.Id)/@Quantity
		From ServiceLiquidations 
		Where Token=@Token



		 Update ServiceLiquidations
		 Set Status=Upper(@Status),
			 Updated=getdate(),
			 PriceMT=@Price,
			 PriceMTNew=(Case When @PriceMT=0 Then @Price else @PriceMT  end)
		From ServiceLiquidations
		Where Token=@Token
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
END