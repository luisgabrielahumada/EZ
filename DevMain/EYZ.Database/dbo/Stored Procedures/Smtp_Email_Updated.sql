CREATE Procedure [dbo].[Smtp_Email_Updated]
	@EntityId int=0
--With Encryption
As
Begin
	/*------------------------------------------------------------------------------
	-- getting xml main list only range: records_[begin,end], setting record status.
	------------------------------------------------------------------------------*/
	Declare @sError varchar(max) ,@IsErrorTecnichal int
	Execute C_Parameter_Get @CodeParameter= 'ERROR_TECNICHAL', @Value= @IsErrorTecnichal OUTPUT
	Begin Try
	------------------------------------------------------------------------------
	-- Declaring variables
	------------------------------------------------------------------------------
	Update dbo.AppSendEmail
	SET StatusSend='OK',
		Updated=getdate()
	where EntityId= @EntityId and StatusSend='PROCESS'
	End Try			
	Begin Catch
		--Getting the error description
		Set @sError  =  ERROR_MESSAGE()
		if @IsErrorTecnichal=1
		Begin
			Set @sError  =   ERROR_PROCEDURE() + 
					';  ' + convert(varchar,ERROR_LINE()) + 
					'; ' + ERROR_MESSAGE()
		End 
		RaisError (@sError,16,1)
		Return		
	End Catch	
End