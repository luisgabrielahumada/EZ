﻿-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DB_VesselChange_Save]
	-- Add the parameters for the stored procedure here
	  @token varchar(max)
	 ,@DailyHire money
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
		 Update Vessel
		 Set RateLoading=@DailyHire,
			 RateUnloading=@DailyHire,
			 UpdatedId=@UpdatedId,
			 Updated=getdate()
		Where Token=@token
	Commit Transaction

	Select RequestForServices.Owner, Vessel.Name,Vessel.RateLoading
	From RequestForServices 
		Inner Join ServiceLiquidations On ServiceLiquidations.RequestForServiceId=RequestForServices.Id
		Inner Join Vessel On Vessel.Id=ServiceLiquidations.VesselId
	Where ServiceLiquidations.Status='REQUEST'
	      and Vessel.Token=@token
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