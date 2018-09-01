CREATE PROCEDURE [dbo].[App_Parameters_List]
	@PageIndex [int] = 1,
	@PageSize [int] = 10,
	@TotalRecords [int] = 0 OUTPUT
--WITH ENCRYPTION
AS
	/*------------------------------------------------------------------------------
		-- getting xml main list only range: records_[begin,end], setting record status.
		--------------------------------------------------------------------------------*/
		Select @TotalRecords=count(*) From [AppParameters]
		------------------------------------------------------------------------------
		-- getting user list
		------------------------------------------------------------------------------		
		SELECT [ParameterId]
			  ,[CodeParameter]
			  ,[ValueId]
			  ,[Parameter]
			  ,[IsBlocked]
			  ,[Updated]
			  ,[Creation]
			  ,[UpdatedId]
			  ,[Control]
			  ,[Observation]
			  ,[Type]
			  ,[Title]
			  ,[IsWidth]
		  FROM [dbo].[AppParameters]
		ORDER BY CURRENT_TIMESTAMP OFFSET (@PageIndex-1)*@PageSize ROWS FETCH FIRST @PageSize ROWS ONLY
		/*-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/