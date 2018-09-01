CREATE PROCEDURE [dbo].[DB_Countries_List]
	@PageIndex [int] = 1,
	@PageSize [int] = 10,
	@TotalRecords [int] = 0 OUTPUT
--WITH ENCRYPTION
AS
Begin
		Select @TotalRecords=count(*) From [Countries]
		;With CTECountries as (
			SELECT Countries.[CountryId]
				  ,[Country]
				  ,Countries.[UpdatedId]
				  ,Countries.[Updated]
				  ,Countries.[Created]
				  ,Countries.[IsActive]
				  ,Token
				  ,Countries.Code
				  ,Countries.CodeInternational
			  FROM [dbo].[Countries]
			 ORDER BY CURRENT_TIMESTAMP OFFSET (@PageIndex-1)*@PageSize ROWS FETCH FIRST @PageSize ROWS ONLY
		 )
		 Select CountryId,Country,UpdatedId,Updated,Created,IsActive,Token,Code,CodeInternational
		 From CTECountries
		 Order By Country asc
End