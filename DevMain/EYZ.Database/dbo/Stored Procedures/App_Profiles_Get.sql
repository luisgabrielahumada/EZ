CREATE PROCEDURE [dbo].[App_Profiles_Get]
	@Token uniqueidentifier
--WITH ENCRYPTION
AS
Declare @sError int,@sError_file_string Varchar(Max) 
		BEGIN TRY
				/*------------------------------------------------------------------------------
				-- getting xml main list only range: records_[begin,end], setting record status.
				------------------------------------------------------------------------------*/
					SELECT	Profile,Section,IsActive,ProfileId ,Token
					FROM Appprofiles
					where Appprofiles.Token=@Token
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