-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
Create FUNCTION [dbo].[GetPropertyValueVessel]
(
	-- Add the parameters for the function here
	@PropertyVesselId int,
	@VesselId int
)
RETURNS varchar(250)
AS
BEGIN
	Declare @Value varchar(250)
	Select @Value=Value
	From PropertyValueVessel 
	where PropertyVesselId=@PropertyVesselId
		  And VesselId=@VesselId
	RETURN @Value

END