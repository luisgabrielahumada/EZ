CREATE PROCEDURE [dbo].[SS_MessageLog_Get]
	@Token uniqueidentifier
--WITH ENCRYPTION
AS
 
 Select
		CAST(JSON_VALUE(Body, '$.StartDate') AS NVARCHAR(35)) AS StartDate,
		CAST(JSON_VALUE(Body, '$.EndDate') AS NVARCHAR(35)) As EndDate,
		CAST(JSON_VALUE(Body, '$.Duration') AS INT) As Duration,
		CAST(JSON_VALUE(Body, '$.ResponseStatus') AS  NVARCHAR(25)) As ResponseStatus,
		CAST(JSON_VALUE(Body, '$.ResponseStatusCode') AS  NVARCHAR(25)) As ResponseStatusCode,
		CAST(JSON_QUERY(Body, '$.ResponseBody') AS  NVARCHAR(max)) As ResponseBody,
		 Message
		,Creation
		,Description
		,Description
		,StatusCode
		,Body
		,MessageId
		,Token
	FROM dbo.AppMessageLog
	Where Token=@Token