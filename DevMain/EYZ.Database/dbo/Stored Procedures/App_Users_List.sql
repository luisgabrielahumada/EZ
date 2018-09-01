CREATE PROCEDURE [dbo].[App_Users_List]
	@PageIndex [int] = 1,
	@PageSize [int] = 10,
	@TotalRecords [int] = 0 OUTPUT,
	@Name varchar(200)='' ,
	@ProfileId [int] = 0 
--WITH ENCRYPTION
AS
	/*------------------------------------------------------------------------------
		-- getting xml main list only range: records_[begin,end], setting record status.
		--------------------------------------------------------------------------------*/
		Select @TotalRecords=count(*) From AppUsers
		------------------------------------------------------------------------------
		-- getting user list
		------------------------------------------------------------------------------		
		Select AppUsers.UserId,Login,RoleId,Email,AppUsers.ProfileId,
				 AppUsers.IsActive,
				AppProfiles.Profile,Name,isnull(IsSysadmin,0) IsSysadmin,isnull(appusers.IsBlock,0) IsBlock,
				AppUsers.Token
		From AppUsers
				Inner Join AppProfiles on AppProfiles.ProfileId=AppUsers.ProfileId
		Where (Name like '%'+ @Name  +'%' or Isnull(@Name,'')='') and(AppProfiles.ProfileId=@ProfileId or Isnull(@ProfileId,0)=0)
		ORDER BY CURRENT_TIMESTAMP OFFSET (@PageIndex-1)*@PageSize ROWS FETCH FIRST @PageSize ROWS ONLY
		/*-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/