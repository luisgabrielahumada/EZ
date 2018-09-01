CREATE PROCEDURE [dbo].[DB_AvailableOpenVessels_Get]
	@Token uniqueidentifier
--WITH ENCRYPTION
AS
BEGIN
	------------------------------------------------------------------------------
	-- Declaring tables
	------------------------------------------------------------------------------
		SELECT AvailableOpenVessels.*
		FROM AvailableOpenVessels
		Inner Join Vessel On AvailableOpenVessels.VesselId=Vessel.Id and AvailableOpenVessels.IsAvailable=1
		Where Vessel.Token= @Token
	-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
END