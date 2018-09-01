CREATE FUNCTION [dbo].[TableSplit](@sInputList [varchar](max), @sDelimiter [varchar](10) = ',')
RETURNS @List TABLE (
	[id_record] [int] IDENTITY(1,1),
	[item] [varchar](max) NULL
)
AS 
BEGIN
	-----------------------------------------------
	--Declare variables
	-----------------------------------------------
	DECLARE @sItem VARCHAR(max)
	-----------------------------------------------
	--Execute Logic
	-----------------------------------------------
	WHILE CHARINDEX(@sDelimiter,@sInputList,0) <> 0 
	BEGIN 
	SELECT  @sItem=RTRIM(LTRIM(SUBSTRING(@sInputList,1,CHARINDEX(@sDelimiter,@sInputList,0)-1))),  
			@sInputList=RTRIM(LTRIM(SUBSTRING(@sInputList,CHARINDEX(@sDelimiter,@sInputList,0)+LEN(@sDelimiter),LEN(@sInputList))))  
		IF LEN(@sItem) > 0  INSERT INTO @List SELECT @sItem 
	END
	-----------------------------------------------
	--Validacion de Tamaños
	-----------------------------------------------
	IF LEN(@sInputList) > 0 
		INSERT INTO @List 
		SELECT @sInputList  
	RETURN
END
GO


