CREATE PROCEDURE [dbo].[DB_Type_List]
	@PageIndex [int] = 1,
	@PageSize [int] = 10,
	@TotalRecords [int] = 0 OUTPUT
--WITH ENCRYPTION
AS

	/*------------------------------------------------------------------------------
		-- getting xml main list only range: records_[begin,end], setting record status.
		--------------------------------------------------------------------------------*/
		Select @TotalRecords=count(*) From Types
		------------------------------------------------------------------------------
		-- getting user list
		------------------------------------------------------------------------------						   
		Select *
		From Types
		ORDER BY CURRENT_TIMESTAMP OFFSET (@PageIndex-1)*@PageSize ROWS FETCH FIRST @PageSize ROWS ONLY
		/*-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/