-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[GetStatusRequest]
(
	@RequestForServiceId int
)
RETURNS varchar(25)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @StatuRequest varchar(25), @CountTotalStatus int

	Select  @CountTotalStatus=Count(Status)
	From ServiceLiquidations
	Where RequestForServiceId=@RequestForServiceId  And Status='REQUEST'

	;With CTEStatusRequest AS (
		Select  Count(Status) as Count,Status,(Case When @CountTotalStatus>=1 and Status='REQUEST' then  'REQUEST'
												When @CountTotalStatus>=1 then  'PARTIAL_ACCEPT' 
												When @CountTotalStatus=0 then 'FULL_ACCEPT' else Status End) as NewStatus
	From ServiceLiquidations
	Where RequestForServiceId=@RequestForServiceId  And Status!='PENDING'
	Group by Status
	)
	 Select Top 1 @StatuRequest=NewStatus 
	 From CTEStatusRequest 
	-- Return the result of the function
	RETURN @StatuRequest

END