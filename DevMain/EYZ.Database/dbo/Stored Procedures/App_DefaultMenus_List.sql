--App_DefaultMenus_List '8BA240FD-43B8-43E9-AA18-352F0DF8613A' 
CREATE PROCEDURE [dbo].[App_DefaultMenus_List] 
	@SessionId varchar(200)
--WITH ENCRYPTION
AS
BEGIN
		/*------------------------------------------------------------------------------
		-- getting xml main list only range: records_[begin,end], setting record status.
		--Sin Asignados
		------------------------------------------------------------------------------*/
		Declare @Menu varchar(300),@FilePage varchar(400),@UserId int,@ProfileId int
		Declare @ds_version varchar(50),@dt_lastupdated datetime 
		
		--Validacion de Session
		SELECT @UserId=AppUsers.UserId,@ProfileId=Appusers.ProfileId
		From Appsessions 
					Inner Join AppUsers On Appsessions.UserId=AppUsers.UserId
		where SessionId=@SessionId

		
		;With CTEMenu as (
		Select AppMenus.ParentId as MenuId,Menu,FilePage,'Items' as Type, Icon as Icon, AppMenus.Token, 0 as Relationship,AppMenus.Alias, AppMenus.IsHorizontal, AppMenus.IsVertical
		From AppMenus
				Inner join AppProfilesMenus on AppProfilesMenus.MenuId=AppMenus.MenuId
					left Join (Select  count(appmenus.ParentId) as am_parent,appmenus.ParentId
									from appmenus
											Inner join AppProfiles on AppProfiles.ProfileId=@ProfileId
											Inner Join AppProfilesMenus on   AppProfilesMenus.MenuId=AppMenus.MenuId
									where AppMenus.IsParent=0 and AppMenus.IsActive =1 and IsView=1 and AppMenus.ParentId>0
									group by AppMenus.ParentId ) Temp1 On Temp1.ParentId=AppMenus.MenuId 
					left Join (Select  count(AppMenus.ParentId) as am_user_parent,appmenus.ParentId
								from AppMenus
										Inner join AppUsers on AppUsers.UserId=@UserId
										Inner Join Appsessions On Appsessions.UserId=AppUsers.UserId
										Inner Join AppAccessUsers on   AppAccessUsers.MenuId=AppMenus.MenuId and AppAccessUsers.MenuId=appmenus.MenuId  and AppAccessUsers.UserId=appusers.UserId
								where AppMenus.IsParent=0 and appmenus.IsActive =1 and IsView=1 and AppAccessUsers.ProfileId=@ProfileId and AppMenus.ParentId>0 and  Appsessions.SessionId=@SessionId
								group by AppMenus.ParentId ) Temp2 On Temp2.ParentId=appmenus.MenuId 
		Where AppProfilesMenus.ProfileId=@ProfileId 
		union
		Select AppMenus.MenuId,Menu, AppMenus.FilePage, 'Parent' as Type, Icon, AppMenus.Token,  (select Count(1) 
																									from AppProfilesMenus 
																									Where AppProfilesMenus.ParentId=AppMenus.MenuId 
																									and IsActive=1 
																									and AppProfilesMenus.ProfileId=AppProfiles.ProfileId) as Relationship,AppMenus.Alias,
				AppMenus.IsHorizontal, AppMenus.IsVertical
		From AppMenus 
				Inner Join AppProfilesMenus On AppMenus.MenuId=AppProfilesMenus.MenuId
			   Inner Join AppProfiles On AppProfilesMenus.ProfileId=AppProfiles.ProfileId  and AppProfiles.ProfileId=@ProfileId
		Where AppMenus.IsParent=1 and AppMenus.IsActive =1
		)
		Select * from CTEMenu
		Order by IsHorizontal asc, IsVertical asc
END
--