CREATE PROCEDURE [dbo].[App_DropDownGeneral_List]
	@Type [varchar](25),
	@CodeParameter [varchar](25) = null,
	@UpdatedId [int]
--WITH ENCRYPTION
AS
BEGIN
		/*------------------------------------------------------------------------------
		-- getting xml main list only range: records_[begin,end], setting record status.
		------------------------------------------------------------------------------*/
		if (@Type='PROFILES') 
		begin
			Select Profile as Value, ProfileId as  ValueId
			From AppProfiles
			Where IsActive=1
		end
		if (@Type='PROFILE_ACCESS') 
		begin
			Select Profile as Value, ProfileId as ValueId
			From AppProfiles
			Where IsActive=1 and ProfileId not in(select ProfileId from AppProfilesmenus where MenuId=convert(int,@CodeParameter))
		end
		if (@Type='USERS_ACCESS') 
		begin
			Select Name as Value, UserId as ValueId
			From AppUsers
			Where IsActive=1 and UserId not in(select UserId 
														from AppAccessUsers where ProfileId=convert(int,@CodeParameter) and AppAccessUsers.MenuId=@UpdatedId group by UserId)
															and ProfileId=convert(int,@CodeParameter)
															
		end
		if (@Type='MENUSPARENT')
		begin
			Select Menu as Value, MenuId as ValueId
			From appmenus
			Where IsActive=1 and IsParent=1
		end
		if (@Type='PARAMDEFAULTPROFILE') 
		begin
			Select Profile as Value , ProfileId as  ValueId, 
					(CASE WHEN (SELECT convert(varchar,ValueId)
								from Appparameters where CodeParameter='DEFAULTPROFILE')=convert(varchar,ProfileId) THEN '1' ELSE '0' END) sel
			From appprofiles
			Where IsActive=1
		end
		if (@Type='CD_COUNTRY')
		begin
				Select Countries.CountryId as ValueId ,Countries.Country as Value
				From Countries
				Where IsActive=1
						order by CountryId asc
		end
		if (@Type='CD_CITIES')
		begin
				Select Cities.CityId as ValueId ,Cities.City as Value
				From Cities
				Where IsActive=1
						order by CityId asc
		end
	/*-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
END