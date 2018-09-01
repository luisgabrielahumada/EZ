CREATE PROCEDURE [dbo].[SS_Access_Permissions_App]
	@SessionId [varchar](400),
	@UpdatedId [int] = 0
--WITH ENCRYPTION
AS
BEGIN
	/*------------------------------------------------------------------------------
		Declares variables No se ha podido actualizar la información.  Intente de nuevo.
	------------------------------------------------------------------------------*/
	/*------------------------------------------------------------------------------
		get current variable stream
	------------------------------------------------------------------------------*/
	/*------------------------------------------------------------------------------
	-- Return successful answer
	--------------------------------------------------------------------------------*/
	
	Select   Appmenus.FilePage,Appmenus.Menu as ds_page,
				(Case When Isnull(AppAccessUsers.IsEdit,0)=0 then Isnull(AppProfilesmenus.IsEdit,0) else Isnull(AppAccessUsers.IsEdit,0) end)   as IsEdit,
				(Case When Isnull(AppAccessUsers.IsAutorization,0)=0 then Isnull(AppProfilesmenus.IsAutorization,0) else Isnull(AppAccessUsers.IsAutorization,0) end)   as IsAutorization,
				(Case When Isnull(AppAccessUsers.IsNew,0)=0 then Isnull(AppProfilesmenus.IsNew,0) else Isnull(AppAccessUsers.IsNew,0) end)   as IsNew,
				(Case When Isnull(AppAccessUsers.IsStatus,0)=0 then Isnull(AppProfilesmenus.IsStatus,0) else Isnull(AppAccessUsers.IsStatus,0) end)   as IsStatus,
				(Case When Isnull(AppAccessUsers.IsView,0)=0 then Isnull(AppProfilesmenus.IsView,0) else Isnull(AppAccessUsers.IsView,0) end)   as IsView,
				(Case When Isnull(AppAccessUsers.IsModify,0)=0 then Isnull(AppProfilesmenus.IsModify,0) else Isnull(AppAccessUsers.IsModify,0) end)   as IsModify,
				(Case When Isnull(AppAccessUsers.IsDelete,0)=0 then Isnull(AppProfilesmenus.IsDelete,0) else Isnull(AppAccessUsers.IsDelete,0) end)   as IsDelete,
				(Case When Isnull(AppAccessUsers.IsSpecial,0)=0 then Isnull(AppProfilesmenus.IsSpecial,0) else Isnull(AppAccessUsers.IsSpecial,0) end)   as IsSpecial,
				AppProfiles.ProfileId,
				Appmenus.MenuId,Appmenus.ParentId
		From AppProfiles
				Inner Join AppProfilesmenus On AppProfilesmenus.ProfileId=AppProfiles.ProfileId
				Inner join Appmenus On Appmenus.MenuId=AppProfilesmenus.MenuId
				Inner Join AppSessions On AppSessions.SessionId=@SessionId --and AppSessions.UserId=@UpdatedId
				Inner Join AppUsers On AppUsers.UserId=AppSessions.UserId and AppProfiles.ProfileId=AppUsers.ProfileId 
				left Join AppAccessUsers On AppAccessUsers.ProfileId=AppProfiles.ProfileId and AppAccessUsers.MenuId=Appmenus.MenuId 
End