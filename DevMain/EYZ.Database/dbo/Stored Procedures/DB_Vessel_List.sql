CREATE PROCEDURE [dbo].[DB_Vessel_List]
	@PageIndex [int] = 1,
	@PageSize [int] = 10,
	@TotalRecords [int] = 0 OUTPUT,
	@Owner int=52
--WITH ENCRYPTION
AS

	/*------------------------------------------------------------------------------
		-- getting xml main list only range: records_[begin,end], setting record status.
		--------------------------------------------------------------------------------*/
	--	Declare  @NexOpeningOn Date,
	--@NexOpeningPort Date,
	--@CurrentPortId [int],
		Select @TotalRecords=count(*) From Vessel

		;With CTEAvailableVessel as (
			Select NextOpeningOn,NextOpeningPort,CurrentPortId,VesselId,Ports.Name as PortName, Terminals.Name as TerminalName
			From dbo.AvailableOpenVessels 
				Inner Join Ports On Ports.Id=CurrentPortId
				Inner Join Terminals On Terminals.Id=CurrentTerminalId
			Where IsAvailable=1
		), PivotCTE AS
		(
			Select *
			From (Select PropertyVessel.Name,PropertyValueVessel.Value, PropertyValueVessel.VesselId,
					NextOpeningOn,NextOpeningPort,CurrentPortId,CTEAvailableVessel.PortName,CTEAvailableVessel.TerminalName
					From PropertyVessel
					right Join PropertyValueVessel On PropertyValueVessel.PropertyVesselId=PropertyVessel.PropertyVesselId
					Left Join CTEAvailableVessel On CTEAvailableVessel.VesselId=PropertyValueVessel.VesselId) as Property

			Pivot(Max(Value) for Name in ([DWT], [GRT], [Cubitfeetcapacity], [Tankercapacity], [LOA], [Beam], [Draft], [Year]
											, [YesNo], [Quantity], [Capacity], [Vesselside], [Reach])) as PVT
		)
		------------------------------------------------------------------------------
		-- getting user list
		------------------------------------------------------------------------------						   
		Select *
		From Vessel
			 Left Join PivotCTE On PivotCTE.VesselId=Vessel.Id
		Where Owner=@Owner
		ORDER BY CURRENT_TIMESTAMP OFFSET (@PageIndex-1)*@PageSize ROWS FETCH FIRST @PageSize ROWS ONLY
		/*-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/