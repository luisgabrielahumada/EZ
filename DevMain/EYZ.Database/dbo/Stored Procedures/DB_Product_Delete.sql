CREATE PROCEDURE [dbo].[DB_Product_Delete]
	@Token uniqueidentifier
--WITH ENCRYPTION
AS
Begin

	--------------------------------------------------------------------------------
	Declare  @sError Varchar(Max) ,@IsErrorTecnichal int
	Execute C_Parameter_Get @CodeParameter= 'ERROR_TECNICHAL', @Value= @IsErrorTecnichal OUTPUT
	--------------------------------------------------------------------------------
	-- Validating parameters
	--------------------------------------------------------------------------------
	--------------------------------------------------------------------------------
	-- Activate/Inactivate Record
	--------------------------------------------------------------------------------
	Begin Try
	If Exists (Select top 1 * 
			   From dbo.StowageFactorByProducts
					Inner Join Products On Products.Id=dbo.StowageFactorByProducts.ProductId
			   Where dbo.Products.Token= @Token)
	Begin
		RaisError('Relationship of row with other table Stowage Factor',16,1)
		Return
	End
	If Exists (Select top 1 * 
			   From dbo.QuantityMTByProducts
					Inner Join Products On Products.Id=dbo.QuantityMTByProducts.ProductId
			   Where dbo.Products.Token= @Token)
	Begin
		RaisError('Relationship of row with other table Quantity MT',16,1)
		Return
	End
	If Exists (Select top 1 * 
			   From dbo.TerminalByProducts
					Inner Join Products On Products.Id=dbo.TerminalByProducts.ProductId
			   Where dbo.Products.Token= @Token)
	Begin
		RaisError('Relationship of row with other table Terminal',16,1)
		Return
	End
	Begin Transaction
			
			Delete From dbo.Products 
			Where Token= @Token

			-- check for errors
			If @@rowcount= 0 
			Begin 
    			RaisError('SQLDELETE_FAILD',16,1)
			End 

	-- if we reach here, success!
	Commit Transaction
	End Try
	Begin Catch
			-- there was an error
			If XACT_STATE() =-1
			Begin
    				Rollback WORK
			End
			If @@trancount >0
			Begin
    				Rollback WORK
			End
			If XACT_STATE() = 1
			Begin
    				Commit WORK
			End
			--Getting the error description
			Set @sError  =   ERROR_MESSAGE()
			if @IsErrorTecnichal=1
			Begin
				Set @sError  =  ERROR_PROCEDURE() + 
					';  ' + convert(varchar,ERROR_LINE()) + 
					'; ' + ERROR_MESSAGE()
			End 
			--Getting the error description
			RaisError (@sError,16,1) 
			Return  
	End Catch
	--------------------------------------------------------------------------------
	-- Returning a Value
	--------------------------------------------------------------------------------
	Select  1
	-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
End