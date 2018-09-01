--DB_TerminalByProducts_Get @Token='4ad7f332-e8da-4f45-bc06-0b753449a557',@type=1
CREATE PROCEDURE [dbo].[DB_TerminalByProducts_Get]
	@Token uniqueidentifier,
	@type int =0
AS
BEGIN
		------------------------------------------------------------------------------
		-- Declaring tables
		------------------------------------------------------------------------------
		if(@type=1)
		Begin
			Select Products.Id,Products.Name,TerminalByProducts.LoadingRate,TerminalByProducts.UnloadingRate,TerminalByProducts.IsActive
			From TerminalByProducts
				 Inner Join Terminals On Terminals.Id=TerminalByProducts.TerminalId
				 Inner Join Products On Products.Id=TerminalByProducts.ProductId
			Where Terminals.Token= @Token
			union 
			Select Id,Name,0 as LoadingRate, 0 as UnLoadingRage,0 as IsActive
			From Products
			Where Products.Id not in (Select Products.Id From TerminalByProducts
											 Inner Join Terminals On Terminals.Id=TerminalByProducts.TerminalId
											 Inner Join Products On Products.Id=TerminalByProducts.ProductId
										Where Terminals.Token= @Token)
		end
		Else
		Begin
			Select Id,Name,0 as LoadingRate, 0 as UnLoadingRage,0 as IsActive
			From Products
		End
		-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
END