CREATE PROCEDURE [dbo].[DB_Terminal_List]
	@PageIndex [int] = 1,
	@PageSize [int] = 10,
	@ProductId [int] = 0,
	@TotalRecords [int] = 0 OUTPUT,
	@Filter varchar(200) ='',
	@PortId int=0
--WITH ENCRYPTION
AS

	/*------------------------------------------------------------------------------
		-- getting xml main list only range: records_[begin,end], setting record status.
		--------------------------------------------------------------------------------*/
		Select @TotalRecords=count(*) From Terminals where IsActive=1
		if(@ProductId>0)
		Begin
			;With CteByProduct as (
					Select TerminalId,LoadingRate,UnLoadingRate
					From TerminalByProducts
					Where ProductId=@ProductId 
			)
			------------------------------------------------------------------------------
			-- getting user list
			------------------------------------------------------------------------------						   
			Select Terminals.*,Conditions.Name as ConditionName,CteByProduct.LoadingRate,CteByProduct.UnLoadingRate
			From Terminals
			Left Join CteByProduct on CteByProduct.TerminalId=Terminals.Id
			Inner Join Conditions On Conditions.Id=Terminals.ConditionId 
			Where Terminals.PortId=@PortId and (Terminals.Name like '%'+ @Filter  +'%' or Isnull(@Filter,'')='') 
				  And Terminals.IsActive=1
			ORDER BY  Terminals._Order asc,Terminals.Name asc
		End
		Else
		Begin 
		Select Terminals.*,Conditions.Name as ConditionName,Ports.Name as PortName,Cities.City as CityName
		From Terminals
			Inner Join Conditions On Conditions.Id=Terminals.ConditionId 
			Inner Join Ports On Ports.Id=Terminals.PortId 
			Inner Join Cities On Cities.CityId=Terminals.CityId 
			Where (Terminals.Name like '%'+ @Filter  +'%' or Isnull(@Filter,'')='') 
			ORDER BY CURRENT_TIMESTAMP OFFSET (@PageIndex-1)*@PageSize ROWS FETCH FIRST @PageSize ROWS ONLY
		end