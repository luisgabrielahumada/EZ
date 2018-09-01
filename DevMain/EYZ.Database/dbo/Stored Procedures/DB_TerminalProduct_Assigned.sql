Create PROCEDURE DB_TerminalProduct_Assigned
	@Token uniqueidentifier
--WITH ENCRYPTION
AS
BEGIN
		------------------------------------------------------------------------------
		-- Declaring tables
		------------------------------------------------------------------------------
		Declare @Id int

		Select @Id=Id
		From Terminals
		Where Token=@Token


		Select Products.Name ,Products.Id
		from Products 
		Where Id Not in (Select Products.Id
						from TerminalByProducts 
							Inner Join  Products On Products.Id=TerminalByProducts.ProductId
						Where TerminalId=@Id)

		Select Products.Name ,Products.Id
		from TerminalByProducts 
			Inner Join  Products On Products.Id=TerminalByProducts.ProductId
		Where TerminalId=@Id

		-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
END