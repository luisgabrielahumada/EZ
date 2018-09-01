CREATE PROCEDURE [dbo].[App_UsersCheckPermissions_Get]
	@MenuId int =0,
	@ProfileId int
--WITH ENCRYPTION
AS
			/*------------------------------------------------------------------------------
			-- getting xml main list only range: records_[begin,end], setting record status.
			--Sin Asignados
			------------------------------------------------------------------------------*/
			SELECT UserAcces
				,[AppAccessUsers].[ProfileId]
				,[AppProfiles].Profile
				,[AppAccessUsers].[MenuId]
				,[AppUsers].[Name]
				,Isnull(IsView,0) as IsView
				,Isnull(IsEdit,0) as IsEdit
				,Isnull([AppAccessUsers].IsAutorization,0) as IsAutorization
				,Isnull(IsStatus,0) as IsStatus
				,Isnull(IsNew,0) as IsNew
				,Isnull(IsModify,0) as IsModify
				,Isnull(IsSpecial,0) as IsSpecial
				,Isnull(IsDelete,0) as IsDelete
				,AppUsers.IsBlock
				,AppUsers.UserId
				,[Appmenus].Token
			FROM [dbo].[AppAccessUsers]
				Inner Join [Appmenus] On [Appmenus].MenuId=[AppAccessUsers].MenuId
				Inner Join AppProfiles On AppProfiles.ProfileId=[AppAccessUsers].ProfileId
				Inner Join AppUsers On AppUsers.ProfileId=AppProfiles.ProfileId and AppUsers.UserId=[AppAccessUsers].UserId
			where AppAccessUsers.MenuId=@MenuId and AppAccessUsers.ProfileId=@ProfileId
			/*-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/