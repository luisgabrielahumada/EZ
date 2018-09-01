CREATE PROCEDURE [dbo].[DB_Cities_Get]
	@Token uniqueidentifier
--WITH ENCRYPTION
AS
BEGIN
		------------------------------------------------------------------------------
		-- Declaring tables
		------------------------------------------------------------------------------
		SELECT [Cities].CityId,[Cities].City,[Cities].Token,[Cities].UpdatedId, Cities.Created as Creation,Cities.Updated,Cities.IsActive,
				Countries.CountryId,Countries.Country,Countries.Code,Countries.CodeInternational,Countries.Token,Countries.UpdatedId,Countries.Created as Creation,Countries.Updated
		FROM [dbo].[Cities] 
		Inner Join Countries On Countries.CountryId=cities.CountryId
		Where Cities.Token= @Token
		-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
END