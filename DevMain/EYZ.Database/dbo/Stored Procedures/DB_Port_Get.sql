CREATE PROCEDURE [dbo].[DB_Port_Get]
	@Token uniqueidentifier
--WITH ENCRYPTION
AS
BEGIN
		------------------------------------------------------------------------------
		-- Declaring tables
		------------------------------------------------------------------------------
		SELECT Ports.*,Countries.CountryId
		FROM Ports
			Inner Join Cities On Cities.CityId=Ports.City
			Inner Join Countries On Countries.CountryId=Cities.CountryId
		Where Ports.Token= @Token
		-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
END