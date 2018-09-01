CREATE PROCEDURE [dbo].[App_Menus_List]
	@PageIndex [int] = 1,
	@PageSize [int] = 10,
	@TotalRecords [int] = 0 OUTPUT,
	@Menu varchar(200) ='',
	@ParentId [int] = 0
--WITH ENCRYPTION
AS

	/*------------------------------------------------------------------------------
		-- getting xml main list only range: records_[begin,end], setting record status.
		--------------------------------------------------------------------------------*/
		Select @TotalRecords=count(*) From Appmenus
		------------------------------------------------------------------------------
		-- getting user list
		------------------------------------------------------------------------------						   
		Select Appmenus.MenuId,Appmenus.FilePage,Appmenus.Help,Appmenus.Menu,
				Appmenus.IsActive,
				(Case When (Appmenus.ParentId is null or Appmenus.ParentId=0)  then 0 else 1 end) as IsParent,
				 Appmenus.IsParentMenu,
				Appmenus2.Menu as Parent,AppMenus.Token,AppMenus.Alias,Appmenus.IsHorizontal,Appmenus.IsVertical
		From Appmenus
			Left Join Appmenus as Appmenus2 On Appmenus2.MenuId=Appmenus.ParentId
		Where (Appmenus.Menu like '%'+ @Menu  +'%' or Isnull(@Menu,'')='') and(Appmenus.ParentId=@ParentId or Isnull(@ParentId,0)=0)	
		ORDER BY CURRENT_TIMESTAMP OFFSET (@PageIndex-1)*@PageSize ROWS FETCH FIRST @PageSize ROWS ONLY
		/*-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/