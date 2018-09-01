CREATE PROCEDURE [dbo].[DB_StowageFactor_List]
	@PageIndex [int] = 1,
	@PageSize [int] = 10,
	@ProductId [int] = 0,
	@TotalRecords [int] = 0 OUTPUT,
	@Filter varchar(200) =''
--WITH ENCRYPTION
AS

	/*------------------------------------------------------------------------------
		-- getting xml main list only range: records_[begin,end], setting record status.
		--------------------------------------------------------------------------------*/
		Select @TotalRecords=count(*) From StowageFactors


		if(@ProductId>0)
		Begin
			;With CteByProduct as (
					Select StowageFactorId,Products.Measure
					From StowageFactorByProducts
							Inner Join Products on Products.Id=StowageFactorByProducts.ProductId
					Where ProductId=@ProductId 
			)
			------------------------------------------------------------------------------
			-- getting user list
			------------------------------------------------------------------------------						   
			Select StowageFactors.*,CteByProduct.Measure
			From StowageFactors
				Inner Join CteByProduct on CteByProduct.StowageFactorId=StowageFactors.Id
			Where StowageFactors.IsActive=1
			ORDER BY Value
			/*-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
		End
		Else
		Begin
			Select StowageFactors.*
			From StowageFactors
			Where  (StowageFactors.Name like '%'+ @Filter  +'%' or Isnull(@Filter,'')='') 
			ORDER BY Value asc, CURRENT_TIMESTAMP OFFSET (@PageIndex-1)*@PageSize ROWS FETCH FIRST @PageSize ROWS ONLY
		End