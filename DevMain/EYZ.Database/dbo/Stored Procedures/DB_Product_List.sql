CREATE PROCEDURE [dbo].[DB_Product_List]
	@PageIndex [int] = 1,
	@PageSize [int] = 10,
	@TotalRecords [int] = 0 OUTPUT,
	@IsActive int=1,
	@Filter varchar(200) =''
--WITH ENCRYPTION
AS

	/*------------------------------------------------------------------------------
		-- getting xml main list only range: records_[begin,end], setting record status.
		--------------------------------------------------------------------------------*/
		Select @TotalRecords=count(*) From Products
		------------------------------------------------------------------------------
		-- getting user list
		------------------------------------------------------------------------------			
		if(@isActive=-1)
		Begin
			Select Products.*, Types.Name as TypeName
			From Products
				Inner Join Types On Types.Id=Products.TypeId
			Where (Products.Name like '%'+ @Filter  +'%' or Isnull(@Filter,'')='')
			ORDER BY Name asc, CURRENT_TIMESTAMP OFFSET (@PageIndex-1)*@PageSize ROWS FETCH FIRST @PageSize ROWS ONLY
		End
		Else
		Begin
			Select Products.*, Types.Name as TypeName
			From Products
				Inner Join Types On Types.Id=Products.TypeId
			Where (Products.Name like '%'+ @Filter  +'%' or Isnull(@Filter,'')='') and (Products.IsActive=@IsActive)
			ORDER BY Name asc, CURRENT_TIMESTAMP OFFSET (@PageIndex-1)*@PageSize ROWS FETCH FIRST @PageSize ROWS ONLY
		End
		/*-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/