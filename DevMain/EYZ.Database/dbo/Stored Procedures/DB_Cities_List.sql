CREATE PROCEDURE [dbo].[DB_Cities_List]
	@PageIndex [int] = 1,
	@PageSize [int] = 10,
	@TotalRecords [int] = 0 OUTPUT,
	@Id int=0
--WITH ENCRYPTION
AS
Begin
		Select @TotalRecords=count(*) From [Cities]
		;With CTECities as (
				SELECT [Cities].CityId,[Cities].City,[Cities].Token,[Cities].UpdatedId, Cities.Created as Creation,Cities.Updated,Cities.IsActive,
						Countries.CountryId,Countries.Country,Countries.Code,Countries.CodeInternational,Countries.Token as TokenCountry,Countries.UpdatedId as UpdatedIdCountry,
						Countries.Created  as CreationCountry,Countries.Updated as UpdatedCountry
				FROM [dbo].[Cities] 
				Inner Join Countries On Countries.CountryId=[Cities].CountryId
				Where (@Id=0 or Countries.CountryId=@Id)
				ORDER BY CURRENT_TIMESTAMP OFFSET (@PageIndex-1)*@PageSize ROWS FETCH FIRST @PageSize ROWS ONLY
		)
		Select *
		From CTECities
		Order By City asc
End