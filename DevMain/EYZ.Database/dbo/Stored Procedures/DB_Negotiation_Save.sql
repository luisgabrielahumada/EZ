-- =============================================
-- Author:      <Author, , Name>
-- Create Date: <Create Date, , >
-- Description: <Description, , >
-- =============================================
CREATE PROCEDURE [dbo].[DB_Negotiation_Save]
(
    -- Add the parameters for the stored procedure here
    @ServiceLiquidationToken uniqueidentifier,
    @IsActive bit,
	@UpdatedId int
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON
	Declare  @sError  Varchar(Max)  ,@IsErrorTecnichal int,@ServiceLiquidationId int,@Id int
	Execute C_Parameter_Get @CodeParameter= 'ERROR_TECNICHAL', @Value= @IsErrorTecnichal OUTPUT
	Begin Try
		Select @ServiceLiquidationId=Id 
		From ServiceLiquidations where ServiceLiquidations.Token=@ServiceLiquidationToken
	Begin Transaction
		if Exists(Select top 1 * from NegotiationsOfRequests Where ServiceLiquidationId=@ServiceLiquidationId)
		Begin
			INSERT INTO [dbo].[HistoryNegotiationsOfRequests]
			([NegotiationsOfRequestId]
			,[Observation]
			,[IsModify]
			,[IsActive])
			Select NegotiationsOfRequestId,Observation,IsModify,DetailNegotiationsOfRequests.IsActive
			from DetailNegotiationsOfRequests
						Inner Join NegotiationsOfRequests On NegotiationsOfRequests.Id=DetailNegotiationsOfRequests.NegotiationsOfRequestId
			where ServiceLiquidationId=@ServiceLiquidationId
		End
		if Not Exists(Select Top 1 NegotiationsOfRequests.Id From NegotiationsOfRequests
								Inner Join ServiceLiquidations On ServiceLiquidations.Id=NegotiationsOfRequests.ServiceLiquidationId
						Where NegotiationsOfRequests.ServiceLiquidationId=@ServiceLiquidationId)
		Begin
			-- Insert statements for procedure here
			INSERT INTO [dbo].[NegotiationsOfRequests]
						([ServiceLiquidationId]
						,[IsActive]
						,[UpdatedId],Status)
			VALUES
				(@ServiceLiquidationId
				,@IsActive
				,@UpdatedId,'TOVESSEL')
			Set @Id=SCOPE_IDENTITY()
		End
		else
		Begin
			Update NegotiationsOfRequests
			Set Status='TOCUSTOMER',
			    Updated=getdate(),
				UpdatedId=@UpdatedId
			From NegotiationsOfRequests
					Inner Join ServiceLiquidations On ServiceLiquidations.Id=NegotiationsOfRequests.ServiceLiquidationId
		    Where NegotiationsOfRequests.ServiceLiquidationId=@ServiceLiquidationId
		End
	Commit Transaction
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
			Set @sError  =   ERROR_PROCEDURE() + 
					';  ' + convert(varchar,ERROR_LINE()) + 
					'; ' + ERROR_MESSAGE()
		End 
		RaisError (@sError,16,1) 
		Return
	End Catch

	Select @Id
END