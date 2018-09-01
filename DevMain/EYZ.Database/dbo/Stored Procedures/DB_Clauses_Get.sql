Create PROCEDURE [dbo].[DB_Clauses_Get]
	@Token uniqueidentifier
--WITH ENCRYPTION
AS
BEGIN
		------------------------------------------------------------------------------
		-- Declaring tables
		------------------------------------------------------------------------------
		SELECT Clauses.*
		FROM Clauses
		Where Clauses.Token= @Token
		-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
END