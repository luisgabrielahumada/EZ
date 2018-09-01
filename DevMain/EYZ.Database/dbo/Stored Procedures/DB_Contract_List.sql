CREATE PROCEDURE [dbo].[DB_Contract_List]
	@PageIndex [int] = 1,
	@PageSize [int] = 10,
	@TotalRecords [int] = 0 OUTPUT,
	@isActive int=-1
AS
		/*------------------------------------------------------------------------------
		-- getting xml main list only range: records_[begin,end], setting record status.
		--------------------------------------------------------------------------------*/
		Select @TotalRecords=count(*) From Contract
		------------------------------------------------------------------------------
		-- getting user list
		------------------------------------------------------------------------------		
		if(@isActive=1)
		Begin				   
			SELECT *
			FROM dbo.Contract
			Where dbo.Contract.IsActive=1
		End
		Else
		Begin
			SELECT *
			FROM dbo.Contract
			ORDER BY Name asc, CURRENT_TIMESTAMP OFFSET (@PageIndex-1)*@PageSize ROWS FETCH FIRST @PageSize ROWS ONLY
		End
		/*-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/