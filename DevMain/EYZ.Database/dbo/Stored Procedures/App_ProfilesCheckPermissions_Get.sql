CREATE PROCEDURE [dbo].[App_ProfilesCheckPermissions_Get]
	@MenuId int =0
--WITH ENCRYPTION
AS
			/*------------------------------------------------------------------------------
			-- getting xml main list only range: records_[begin,end], setting record status.
			--Sin Asignados
			------------------------------------------------------------------------------*/
			SELECT [ProfileMenuId]
				,[AppProfilesmenus].[ParentId]
				,[AppProfilesmenus].[IsVertical]
				,[AppProfilesmenus].[IsHorizontal]
				,[AppProfilesmenus].[IsActive]
				,[AppProfilesmenus].[ProfileId]
				,[AppProfiles].Profile
				,[AppProfilesmenus].[MenuId]
				,[AppMenus].[Menu]
				,Isnull(IsView,0) as IsView
				,Isnull(IsEdit,0) as IsEdit
				,Isnull([AppProfilesmenus].IsAutorization,0) as IsAutorization
				,Isnull(IsStatus,0) as IsStatus
				,Isnull(IsNew,0) as IsNew
				,Isnull(IsModify,0) as IsModify
				,Isnull(IsSpecial,0) as IsSpecial
				,Isnull(IsDelete,0) as IsDelete
				,AppProfiles.IsBlock
				,[Appmenus].Token
			FROM [dbo].[AppProfilesmenus]
				Inner Join AppProfiles On AppProfiles.ProfileId=[AppProfilesmenus].ProfileId
				Inner Join [Appmenus] On [Appmenus].MenuId=[AppProfilesmenus].MenuId
			where AppProfilesmenus.MenuId=@MenuId
			/*-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/