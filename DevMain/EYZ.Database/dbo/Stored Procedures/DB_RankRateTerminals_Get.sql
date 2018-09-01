CREATE PROCEDURE [dbo].[DB_RankRateTerminals_Get]
	@Token uniqueidentifier
--WITH ENCRYPTION
AS
BEGIN
		------------------------------------------------------------------------------
		-- Declaring tables
		------------------------------------------------------------------------------
		SELECT RankRateTerminals.*
		FROM RankRateTerminals 
			Inner Join Terminals On Terminals.Id=RankRateTerminals.TerminalId
		Where Terminals.Token= @Token
		-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
END