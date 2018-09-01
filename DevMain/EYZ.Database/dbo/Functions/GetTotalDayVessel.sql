-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[GetTotalDayVessel]
(
	-- Add the parameters for the function here
	@VesselId int,
	@ServiceLiquidationId int

)
RETURNS money
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Total money 

	-- Add the T-SQL statements to compute the return value here
	Select @Total=Sum(CurrentPortAtLoadPort+LoadingPort+CanalPanama+LoadPortAtUnloadingPort+UnLoadPort)
	from ItemsLiquidation 
	Where VesselId=@VesselId and ServiceLiquidationId=@ServiceLiquidationId And IsPrice=0 and Route=RTrim(LTrim('03-HOURS'))

	-- Return the result of the function
	RETURN @Total

END