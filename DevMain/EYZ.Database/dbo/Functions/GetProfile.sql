-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[GetProfile]
(
	-- Add the parameters for the function here
	@UpdatedId int
)
RETURNS varchar(50)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Section varchar(50) 

	-- Add the T-SQL statements to compute the return value here
	 Select @Section=AppProfiles.Section
	 From AppProfiles
		Inner Join AppUsers On AppUsers.UserId=@UpdatedId and AppUsers.ProfileId=AppProfiles.ProfileId

	-- Return the result of the function
	RETURN @Section

END