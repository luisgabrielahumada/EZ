CREATE PROCEDURE [dbo].[SS_MessageLog_List]
		@PageIndex [int] = 1,
	@PageSize [int] = 10,
	@TotalRecords [int] = 0 OUTPUT
--WITH ENCRYPTION
AS
	/*------------------------------------------------------------------------------
	-- getting xml main list only range: records_[begin,end], setting record status.
	--------------------------------------------------------------------------------*/
	Select @TotalRecords=count(*) From [AppMessageLog]
	------------------------------------------------------------------------------
	-- getting user list
	------------------------------------------------------------------------------						   
	SELECT MessageId
		,[Message]
		,[Description]
		,[Creation]
		,[StatusCode]
		,Body
		,Token
		 ,CAST(JSON_VALUE(Body, '$.StartDate') AS NVARCHAR(35)) AS StartDate,
		CAST(JSON_VALUE(Body, '$.EndDate') AS NVARCHAR(35)) As EndDate,
		CAST(JSON_VALUE(Body, '$.Duration') AS INT) As Duration,
		CAST(JSON_VALUE(Body, '$.ResponseStatus') AS  NVARCHAR(25)) As ResponseStatus,
		CAST(JSON_VALUE(Body, '$.ResponseStatusCode') AS  NVARCHAR(25)) As ResponseStatusCode 
	FROM [dbo].[AppMessageLog]
	ORDER BY MessageId desc, CURRENT_TIMESTAMP OFFSET (@PageIndex-1)*@PageSize ROWS FETCH FIRST @PageSize ROWS ONLY
	/*-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/