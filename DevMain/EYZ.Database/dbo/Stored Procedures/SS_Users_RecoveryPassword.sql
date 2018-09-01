CREATE PROCEDURE [dbo].[SS_Users_RecoveryPassword]
	@Email [varchar](100),
	@UpdatedId int=0
--WITH ENCRYPTION
AS
BEGIN
		/*------------------------------------------------------------------------------
		-- declaracion de variables
		--------------------------------------------------------------------------------*/
	Declare @IsErrorTecnichal int,@sError varchar(max)
	Execute C_Parameter_Get @CodeParameter= 'ERROR_TECNICHAL', @Value= @IsErrorTecnichal OUTPUT
	BEGIN TRY
		if Not Exists (Select Top 1 * From AppUsers Where Email=@Email)
		Begin
			RaisError('No existe  email %s ',16,1, @Email)
			return
		End

		Exec BG_EmailQueue_Save
			 @ToEmail =@Email
			,@EmailTo ='RECOVERY_PASSWORD'
			,@UpdatedId =0 
	END TRY
	Begin Catch
    	    --Getting the error description
    	    Set @sError  =   ERROR_MESSAGE()
			if @IsErrorTecnichal=1
			Begin
				Set @sError  =  ERROR_PROCEDURE() + 
					';  ' + convert(varchar,ERROR_LINE()) + 
					'; ' + ERROR_MESSAGE()
			End  
    	    -- save the error in a Log file
    	    RaisError(@sError,16,1) 
    	    Return  
    End Catch
END