CREATE PROCEDURE [dbo].[DB_Terminal_Get]
	@Token uniqueidentifier
--WITH ENCRYPTION
AS
BEGIN
		------------------------------------------------------------------------------
		-- Declaring tables
		------------------------------------------------------------------------------
		SELECT Terminals.*,Ports.Name as PortName
		FROM Terminals
			Inner Join Ports On Terminals.PortId=Ports.Id
		Where Terminals.Token= @Token
		-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
END