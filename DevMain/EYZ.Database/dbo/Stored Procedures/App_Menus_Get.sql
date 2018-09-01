CREATE PROCEDURE [dbo].[App_Menus_Get]
	@Token uniqueidentifier
--WITH ENCRYPTION
AS
BEGIN
	Declare @sError_file_string Varchar(Max) 
	BEGIN TRY
			/*------------------------------------------------------------------------------
			-- getting xml main list only range: records_[begin,end], setting record status.
			------------------------------------------------------------------------------*/
				SELECT [MenuId]
					  ,[FilePage]
					  ,[IsActive]
					  ,[Creation]
					  ,[Updated]
					  ,[UpdatedId]
					  ,[Menu]
					  ,[ParentId]
					  ,[Help]
					  ,[IsVertical]
					  ,[IsHorizontal]
					  ,[IsParent]
					  ,[IsParentMenu]
					  ,[IsAutorization]
					  ,Token
					   ,Icon
					   ,Alias
				  FROM [dbo].[AppMenus]
				where Token=@Token
	END TRY
	Begin Catch
			--Getting the error description
			Select @sError_file_string   =  ERROR_PROCEDURE() + 
					';  ' + convert(varchar,ERROR_LINE()) + 
					'; ' + ERROR_MESSAGE()
			-- save the error in a Log file
			RaisError(@sError_file_string,16,1)
			Return  
	End Catch		
END