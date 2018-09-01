CREATE PROCEDURE [dbo].[DB_Port_List]
	@PageIndex [int] = 1,
	@PageSize [int] = 10,
	@TotalRecords [int] = 0 OUTPUT,
	@Filter varchar(200) ='',
	@isActive int=1
--WITH ENCRYPTION
AS

	/*------------------------------------------------------------------------------
		-- getting xml main list only range: records_[begin,end], setting record status.
		--------------------------------------------------------------------------------*/
		Select @TotalRecords=count(*) From Ports
		------------------------------------------------------------------------------
		-- getting user list
		------------------------------------------------------------------------------		
		if(@isActive=-1)
		Begin				   
			SELECT [Id]
				  ,Ports.Token
				  ,[Name]+', '+Countries.CodeInternational as Name
				  ,[Address]
				  ,[Phone]
				  ,Ports.City
				  ,Cities.City as CityName
				  ,[Ifo]
				  ,[Mgo]
				  ,[Terms]
				  ,[Creation]
				  ,Ports.Updated
				  ,Ports.IsActive
				  ,Ports.UpdatedId
			  FROM dbo.Ports
				 Inner Join Cities On Ports.City=Cities.CityId
				 Inner Join Countries On Countries.CountryId=Cities.CountryId
			Where (Ports.Name like '%'+ @Filter  +'%' or Isnull(@Filter,'')='') 
			And dbo.Ports.IsActive=1
			ORDER BY Name asc, CURRENT_TIMESTAMP OFFSET (@PageIndex-1)*@PageSize ROWS FETCH FIRST @PageSize ROWS ONLY
		End
		Else
		Begin
			SELECT [Id]
				  ,Ports.Token
				  ,[Name]+', '+Countries.CodeInternational as Name
				  ,[Address]
				  ,[Phone]
				  ,Ports.City
				  ,Cities.City as CityName
				  ,[Ifo]
				  ,[Mgo]
				  ,[Terms]
				  ,[Creation]
				  ,Ports.Updated
				  ,Ports.IsActive
				  ,Ports.UpdatedId
			  FROM dbo.Ports
				 Inner Join Cities On Ports.City=Cities.CityId
				 Inner Join Countries On Countries.CountryId=Cities.CountryId
			Where (Ports.Name like '%'+ @Filter  +'%' or Isnull(@Filter,'')='') 
					
			ORDER BY Name asc, CURRENT_TIMESTAMP OFFSET (@PageIndex-1)*@PageSize ROWS FETCH FIRST @PageSize ROWS ONLY
		End
		/*-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/