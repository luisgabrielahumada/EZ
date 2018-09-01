Create PROCEDURE DB_StowageFactorProduct_Assigned
	@Token uniqueidentifier
--WITH ENCRYPTION
AS
BEGIN
		------------------------------------------------------------------------------
		-- Declaring tables
		------------------------------------------------------------------------------
		Declare @Id int

		Select @Id=Id
		From StowageFactors
		Where Token=@Token


		Select Products.Name ,Products.Id
		from Products 
		Where Id Not in (Select Products.Id
						from StowageFactorByProducts 
							Inner Join  Products On Products.Id=StowageFactorByProducts.ProductId
						Where StowageFactorId=@Id)

		Select Products.Name ,Products.Id
		from StowageFactorByProducts 
			Inner Join  Products On Products.Id=StowageFactorByProducts.ProductId
		Where StowageFactorId=@Id

		-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
END