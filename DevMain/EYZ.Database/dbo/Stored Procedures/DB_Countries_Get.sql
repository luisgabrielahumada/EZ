CREATE PROCEDURE [dbo].[DB_Countries_Get]
	@Token uniqueidentifier
--WITH ENCRYPTION
AS
BEGIN
		------------------------------------------------------------------------------
		-- Declaring tables
		------------------------------------------------------------------------------
			SELECT [CountryId]
			  ,[Country]
			  ,[CodeInternational]
			  ,[Code]
			  ,[UpdatedId]
			  ,[Updated]
			  ,Created
			  ,[IsActive]
			  ,Token
		  FROM [dbo].[Countries]
		Where Countries.Token= @Token
		-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
END