CREATE PROCEDURE [dbo].[App_Users_Get]
	@Token uniqueidentifier
--WITH ENCRYPTION
AS
begin
Declare @sError int,@sError_file_string Varchar(Max)
 
BEGIN TRY
		/*------------------------------------------------------------------------------
		-- getting xml main list only range: records_[begin,end], setting record status.
		------------------------------------------------------------------------------*/
			SELECT	UserId,Login,RoleId,Appusers.IsActive,Name,Email,Appusers.ProfileId,Profile,Password,IsSysadmin ,Appusers.Token
			FROM Appusers
					Inner Join appprofiles On appprofiles.ProfileId=Appusers.ProfileId
			where Appusers.Token=@Token
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
end