Create PROCEDURE [dbo].[DB_Condition_List]
	@PageIndex [int] = 1,
	@PageSize [int] = 10,
	@TotalRecords [int] = 0 OUTPUT,
	@Filter varchar(200) =''
--WITH ENCRYPTION
AS

	/*------------------------------------------------------------------------------
		-- getting xml main list only range: records_[begin,end], setting record status.
		--------------------------------------------------------------------------------*/
		Select @TotalRecords=count(*) From Conditions
		------------------------------------------------------------------------------
		-- getting user list
		------------------------------------------------------------------------------						   
		Select *
		From Conditions
		Where  (Conditions.Name like '%'+ @Filter  +'%' or Isnull(@Filter,'')='') 
		ORDER BY CURRENT_TIMESTAMP OFFSET (@PageIndex-1)*@PageSize ROWS FETCH FIRST @PageSize ROWS ONLY
		/*-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/