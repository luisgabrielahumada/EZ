CREATE PROCEDURE [dbo].[DB_ConditionPort_Assigned]
	@Token uniqueidentifier=null
--WITH ENCRYPTION
AS
BEGIN
		------------------------------------------------------------------------------
		-- Declaring tables
		------------------------------------------------------------------------------
		Declare @Id int

		Select @Id=Id
		From Conditions
		Where Token=@Token


		Select Ports.Name ,Ports.Id
		from Ports 
		Where Id Not in (Select Ports.Id
						from ConditionByPorts 
							Inner Join  Ports On Ports.Id=ConditionByPorts.PortId
						Where ConditionId=@Id)

		Select Ports.Name ,Ports.Id
		from ConditionByPorts 
			Inner Join  Ports On Ports.Id=ConditionByPorts.PortId
		Where ConditionId=@Id

		-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
END