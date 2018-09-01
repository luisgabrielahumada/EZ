CREATE PROCEDURE [dbo].[DB_QuantityProduct_Assigned]
	@Token uniqueidentifier=null
--WITH ENCRYPTION
AS
BEGIN
		------------------------------------------------------------------------------
		-- Declaring tables
		------------------------------------------------------------------------------
		Declare @Id int

		Select @Id=Id
		From QuantityMT
		Where Token=@Token


		Select Products.Name ,Products.Id
		from Products 
		Where Id Not in (Select Products.Id
						from QuantityMTByProducts 
							Inner Join  Products On Products.Id=QuantityMTByProducts.ProductId
						Where QuantityMTId=@Id)

		Select Products.Name ,Products.Id
		from QuantityMTByProducts 
			Inner Join  Products On Products.Id=QuantityMTByProducts.ProductId
		Where QuantityMTId=@Id

		-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
END