CREATE PROCEDURE [dbo].[App_Upload_Get]
	@Upload varchar(50)=null,
	@UpdatedId int=0
--WITH ENCRYPTION
AS
Declare @sError int,@sError_file_string Varchar(Max) 
		BEGIN TRY
				/*------------------------------------------------------------------------------
				-- getting xml main list only range: records_[begin,end], setting record status.
				------------------------------------------------------------------------------*/
					SELECT [UploadId]
						  ,[Upload]
						  ,[Body]
						  ,[UpdatedId]
						  ,[Creation]
						  ,[Updated]
						  ,[FileName]
					FROM [dbo].[AppUploads]
					where (@Upload =Upload or Isnull(@Upload,'')='')
				/*-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
		END TRY
		Begin Catch
	    --Getting the error description
	    Select @sError_file_string  =  ERROR_PROCEDURE() + 
					';  ' + convert(varchar,ERROR_LINE()) + 
					'; ' + ERROR_MESSAGE()
	    -- save the error in a Log file
	    RaisError(@sError_file_string,16,1)
	    Return  
End Catch