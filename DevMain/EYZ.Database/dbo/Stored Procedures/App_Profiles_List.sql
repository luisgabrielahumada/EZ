CREATE PROCEDURE [dbo].[App_Profiles_List]
	@PageIndex [int] = 1,
	@PageSize [int] = 10,
	@TotalRecords [int] = 0 OUTPUT
--WITH ENCRYPTION
AS
		Select @TotalRecords=count(*) From AppProfiles
		------------------------------------------------------------------------------
		-- getting user list
		------------------------------------------------------------------------------						   
		Select AppProfiles.ProfileId,AppProfiles.Profile,Section,
				 AppProfiles.IsActive,IsBlock,Token
		From AppProfiles
		ORDER BY CURRENT_TIMESTAMP OFFSET (@PageIndex-1)*@PageSize ROWS FETCH FIRST @PageSize ROWS ONLY
		/*-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/