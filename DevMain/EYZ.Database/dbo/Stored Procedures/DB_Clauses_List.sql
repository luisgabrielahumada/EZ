CREATE PROCEDURE [dbo].[DB_Clauses_List]
	@PageIndex [int] = 1,
	@PageSize [int] = 10,
	@TotalRecords [int] = 0 OUTPUT,
	@isActive int=-1,
	@ContractToken uniqueidentifier= null
AS
		/*------------------------------------------------------------------------------
		-- getting xml main list only range: records_[begin,end], setting record status.
		--------------------------------------------------------------------------------*/
		Select @TotalRecords=count(*) From Clauses
		------------------------------------------------------------------------------
		-- getting user list
		------------------------------------------------------------------------------		
		if(@isActive=1)
		Begin			
			;With CteByContract as (
					Select ClauseId, ContractId, 1 as IsSelected
					From ContractClauses
						 Inner Join Contract On Contract.Token=@ContractToken and ContractClauses.ContractId=Contract.Id
			)
			SELECT Clauses.*,IsNull(CteByContract.IsSelected,0)  as IsSelected
			FROM dbo.Clauses
			Left Join CteByContract on CteByContract.ClauseId=Clauses.Id
			ORDER BY Name asc
		End
		Else
		Begin
			SELECT *
			FROM dbo.Clauses
			ORDER BY Name asc, CURRENT_TIMESTAMP OFFSET (@PageIndex-1)*@PageSize ROWS FETCH FIRST @PageSize ROWS ONLY
		End
		/*-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/