CREATE PROCEDURE [dbo].[DB_PropertyToVessel_List]
	@Token uniqueidentifier=null,
	@UpdatedId int=0,
	@Owner int=0
--WITH ENCRYPTION
AS

	/*------------------------------------------------------------------------------
		-- getting xml main list only range: records_[begin,end], setting record status.
		--------------------------------------------------------------------------------*/
		Declare @Id int
		------------------------------------------------------------------------------
		-- getting user list
		------------------------------------------------------------------------------						   
		Select @Id=Id
		From Vessel
		Where Vessel.Token=@Token
		/*-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/

		Select  PropertyVessel.Code,PropertyVessel.Name, Convert(varchar(250),PropertyValueVessel.Value,1) as Value,PropertyVessel.PropertyVesselId
		From PropertyVessel
					Left Join PropertyValueVessel On PropertyVessel.PropertyVesselId=PropertyValueVessel.PropertyVesselId and (PropertyValueVessel.VesselId=@Id or @Id=0)
		Where PropertyVessel.IsActive=1