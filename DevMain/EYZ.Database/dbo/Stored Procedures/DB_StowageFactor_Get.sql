Create PROCEDURE DB_StowageFactor_Get
	@Token uniqueidentifier
--WITH ENCRYPTION
AS
BEGIN
		------------------------------------------------------------------------------
		-- Declaring tables
		------------------------------------------------------------------------------
		SELECT *
		FROM StowageFactors
		Where Token= @Token
		-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
END