-- DB_VesselProduct_Assigned '13eca2a8-a615-4d02-8cba-efe11e91e39a'
CREATE PROCEDURE [dbo].[DB_VesselProduct_Assigned]
	@Token uniqueidentifier
--WITH ENCRYPTION
AS
BEGIN
		------------------------------------------------------------------------------
		-- Declaring tables
		------------------------------------------------------------------------------
		Declare @Id int

		Select @Id=Id
		From Vessel
		Where Token=@Token

		Select Products.Name ,Products.Id
		from Products 
		Where Id Not in (Select Products.Id
						from ProductByVessels 
							Inner Join  Products On Products.Id=ProductByVessels.ProductId
						Where VesselId=@Id)

		Select Products.Name ,Products.Id
		from ProductByVessels 
			Inner Join  Products On Products.Id=ProductByVessels.ProductId
		Where VesselId=@Id

		-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
END