CREATE PROCEDURE [dbo].[App_MenusAssignCheckPermissions_List]
	@SessionId varchar(200) =''
--WITH ENCRYPTION
AS
/*------------------------------------------------------------------------------
-- getting xml main list only range: records_[begin,end], setting record status.
--Sin Asignados
------------------------------------------------------------------------------*/
Select Appmenus.MenuId, Appmenus.Menu,Appmenus.FilePage ,Appmenus.ParentId,Appmenus.IsActive,'Parent' as ds_type
From Appmenus
Where   Appmenus.IsParent=1
Union
Select Appmenus.MenuId, Appmenus.Menu,Appmenus.FilePage ,Appmenus.ParentId,Appmenus.IsActive,'ParentHuerfano' as ds_type
From Appmenus
Where  Appmenus.ParentId=-1
Union
Select Appmenus.MenuId, Appmenus.Menu,Appmenus.FilePage,Appmenus.ParentId,Appmenus.IsActive,'Items' as ds_type
From Appmenus
Where   Isnull(Appmenus.IsParent,0)=0 and Appmenus.ParentId>0
/*-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/