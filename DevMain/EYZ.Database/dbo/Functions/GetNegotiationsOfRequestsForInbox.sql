-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[GetNegotiationsOfRequestsForInbox]
(
	-- Add the parameters for the function here
	@ServiceLiquidationId int
)
RETURNS varchar(50)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Token uniqueidentifier
	Set @Token=null
	Select @Token=Token 
	From NegotiationsOfRequests 
	Where NegotiationsOfRequests.ServiceLiquidationId=@ServiceLiquidationId

	-- Return the result of the function
	RETURN @Token

END