CREATE PROCEDURE [dbo].[DB_Quantity_List]
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
		Select @TotalRecords=count(*) From QuantityMT
		if(@ProductId>0)
		Begin
			;With CteByProduct as (
					Select QuantityMTId,Products.MeasureQuantity
					From QuantityMTByProducts
						Inner join Products on Products.Id=QuantityMTByProducts.ProductId
					Where ProductId=@ProductId
			)
			------------------------------------------------------------------------------
			-- getting user list
			------------------------------------------------------------------------------						   
			Select QuantityMT.*,CteByProduct.MeasureQuantity as Measure
			From QuantityMT
			Inner Join CteByProduct on CteByProduct.QuantityMTId=QuantityMT.Id
			Where QuantityMT.IsActive=1
			ORDER BY Quantity asc
			/*-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
		End
		else
		Begin
			Select QuantityMT.*
			From QuantityMT
			Where (QuantityMT.Name like '%'+ @Filter  +'%' or Isnull(@Filter,'')='') 
			ORDER BY Quantity asc, CURRENT_TIMESTAMP OFFSET (@PageIndex-1)*@PageSize ROWS FETCH FIRST @PageSize ROWS ONLY
		End