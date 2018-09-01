CREATE PROCEDURE [dbo].[App_AssignCheckPermissions_List]
	@SessionId varchar(200) =''
--WITH ENCRYPTION
AS
/*------------------------------------------------------------------------------
-- getting xml main list only range: records_[begin,end], setting record status.
--Sin Asignados
------------------------------------------------------------------------------*/
Select Appmenus.MenuId, Appmenus.Menu,Appmenus.FilePage ,Appmenus.ParentId,Appmenus.IsActive,Token,'Parent' as Type
From Appmenus
Where   Appmenus.IsParent=1
Union
Select Appmenus.MenuId, Appmenus.Menu,Appmenus.FilePage ,Appmenus.ParentId,Appmenus.IsActive,Token,'ParentHuerfano' as Type
From Appmenus
Where  Appmenus.ParentId=-1
Union
Select Appmenus.MenuId, Appmenus.Menu,Appmenus.FilePage,Appmenus.ParentId,Appmenus.IsActive,Token,'Items' as Type
From Appmenus
Where   Isnull(Appmenus.IsParent,0)=0 and Appmenus.ParentId>0
/*-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/