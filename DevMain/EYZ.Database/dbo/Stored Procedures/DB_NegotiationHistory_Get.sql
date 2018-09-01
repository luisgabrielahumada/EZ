-- =============================================
-- Author:      <Author, , Name>
-- Create Date: <Create Date, , >
-- Description: <Description, , >
-- =============================================
--DB_NegotiationHistory_Get '7f72641a-347f-4409-80c1-058b37bee917'
CREATE PROCEDURE [dbo].[DB_NegotiationHistory_Get]
(
    -- Add the parameters for the stored procedure here
     @Token uniqueidentifier
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON
	Declare  @sError  Varchar(Max)  ,@IsErrorTecnichal int,@ServiceLiquidationId int,@Id int
	Execute C_Parameter_Get @CodeParameter= 'ERROR_TECNICHAL', @Value= @IsErrorTecnichal OUTPUT
	
	Select NegotiationsOfRequests.id,NegotiationsOfRequests.ServiceLiquidationId, NegotiationsOfRequests.Status,NegotiationsOfRequests.Token,
	      NegotiationsOfRequests.IsActive,NegotiationsOfRequests.UpdatedId,ServiceLiquidations.Token as ServiceLiquidationToken, 
		   (Select  HistoryNegotiationsOfRequests.Observation as OldObservation,'' as Observation
			From HistoryNegotiationsOfRequests
					Inner Join (Select NegotiationsOfRequests.Id 
								from NegotiationsOfRequests
									Inner Join ServiceLiquidations On ServiceLiquidations.Id=NegotiationsOfRequests.ServiceLiquidationId
								Where ServiceLiquidations.Token=@Token) as Negotiations On Negotiations.Id=HistoryNegotiationsOfRequests.NegotiationsOfRequestId FOR JSON PATH, ROOT('History')) as DetailNegotiation
	From NegotiationsOfRequests
			Inner Join ServiceLiquidations On ServiceLiquidations.Id=NegotiationsOfRequests.ServiceLiquidationId
	Where ServiceLiquidations.Token=@Token
END