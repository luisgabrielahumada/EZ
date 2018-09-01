﻿-- =============================================
-- Author:      <Author, , Name>
-- Create Date: <Create Date, , >
-- Description: <Description, , >
-- =============================================
CREATE PROCEDURE [dbo].[DB_Negotiation_Get]
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
		   (Select DetailNegotiationsOfRequests.id, DetailNegotiationsOfRequests.Token,DetailNegotiationsOfRequests.NegotiationsOfRequestId,
				   DetailNegotiationsOfRequests.IsModify,DetailNegotiationsOfRequests.Observation, DetailNegotiationsOfRequests.OldObservation
			From DetailNegotiationsOfRequests
					Inner Join NegotiationsOfRequests On NegotiationsOfRequests.Id=DetailNegotiationsOfRequests.NegotiationsOfRequestId
					Inner Join ServiceLiquidations On ServiceLiquidations.Id=NegotiationsOfRequests.ServiceLiquidationId
			Where ServiceLiquidations.Token=@Token FOR JSON PATH, ROOT('DetailNegotiation')) as DetailNegotiation
	From NegotiationsOfRequests
			Inner Join ServiceLiquidations On ServiceLiquidations.Id=NegotiationsOfRequests.ServiceLiquidationId
	Where ServiceLiquidations.Token=@Token
END