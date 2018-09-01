-- DB_Vessel_Get null, 8
CREATE PROCEDURE [dbo].[DB_Vessel_Get]
	@Token uniqueidentifier=null,
	@Id int=0
--WITH ENCRYPTION
AS
BEGIN
		
		------------------------------------------------------------------------------
		-- Declaring tables
		------------------------------------------------------------------------------
		;With CTEAvailableVessel as (
			Select NextOpeningOn,NextOpeningPort,CurrentPortId,VesselId,Ports.Name as PortName, Terminals.Name as TerminalName
			From dbo.AvailableOpenVessels 
				Inner Join Ports On Ports.Id=CurrentPortId
				Inner Join Terminals On Terminals.Id=CurrentTerminalId
			Where IsAvailable=1
		)
		SELECT *, Cities.City, AppUsers.Name as OwnerName,CTEAvailableVessel.NextOpeningOn,CTEAvailableVessel.NextOpeningPort,CTEAvailableVessel.PortName,
				Countries.Code as Country, Countries.CountryId
		FROM Vessel
			Inner Join Cities On Cities.CityId=Vessel.CityId
			Inner Join Countries On Cities.CountryId=Countries.CountryId
			Inner Join AppUsers On AppUsers.UserId=Vessel.Owner
			Left Join CTEAvailableVessel On CTEAvailableVessel.VesselId=Vessel.Id
		Where (Vessel.Token= @Token Or Vessel.Id=@Id)
		-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
END