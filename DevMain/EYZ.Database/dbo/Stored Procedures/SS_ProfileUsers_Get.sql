CREATE PROCEDURE [dbo].[SS_ProfileUsers_Get]
	@SessionId varchar(50)
--WITH ENCRYPTION
AS
begin
Declare @sError int,@sError_file_string Varchar(Max),@UserId [int]
 
BEGIN TRY
		/*------------------------------------------------------------------------------
		-- getting xml main list only range: records_[begin,end], setting record status.
		------------------------------------------------------------------------------*/
			SELECT	Appusers.UserId,Login,RoleId,Appusers.IsActive,Name,Email,Appusers.ProfileId,Profile,Password,IsSysadmin,
			AppSessions.SessionId,AppSessions.Creation,AppSessions.Updated,Appusers.Token
			FROM Appusers
					Inner Join Appprofiles On appprofiles.ProfileId=Appusers.ProfileId
					Inner Join AppSessions On SessionId=@SessionId and AppSessions.UserId=Appusers.UserId
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