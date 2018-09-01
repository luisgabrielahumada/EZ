CREATE PROCEDURE [dbo].[DB_DistanceBetweenPorts_List]
AS
Begin
	;with cteDistanceBetweenPorts as 
	(  Select Distinct DistanceBetweenPorts.InputPortId,DistanceBetweenPorts.OutPutPortId,
		InputPort.Name as InputName,OutPutPort.Name as OutPutName,DistanceBetweenPorts.Interval,
		DistanceBetweenPorts.HourCanalPanama,  DistanceBetweenPorts.InputPortId-DistanceBetweenPorts.OutPutPortId as Diff,
		DistanceBetweenPorts.IsActive
		from DistanceBetweenPorts
		Inner Join Ports as InputPort On InputPort.Id=DistanceBetweenPorts.InputPortId
		Inner Join Ports as OutPutPort On OutPutPort.Id=DistanceBetweenPorts.OutPutPortId
	 )
 Select * from cteDistanceBetweenPorts  where Diff>0
End