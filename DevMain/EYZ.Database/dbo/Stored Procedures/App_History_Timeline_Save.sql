﻿CREATE PROCEDURE [dbo].[App_History_Timeline_Save]
	@SessionId [varchar](250),
	@UpdatedId [int],
	@Type varchar(50),
	@TimeLine varchar(50),
	@Comments varchar(max)
--WITH ENCRYPTION
AS
BEGIN
	/*------------------------------------------------------------------------------
		Declares variables No se ha podido actualizar la información.  Intente de nuevo.
	------------------------------------------------------------------------------*/
	Declare @IsErrorTecnichal int, @sError varchar(max)
	Execute C_Parameter_Get @CodeParameter= 'ERROR_TECNICHAL', @Value= @IsErrorTecnichal OUTPUT
	/*------------------------------------------------------------------------------
		get current variable stream
	------------------------------------------------------------------------------*/
	begin try
		begin  Transaction
		INSERT INTO [dbo].[AppHistoryTimeline]
				   ([Type]
				   ,[Comments]
				   ,[UpdatedId]
				   ,[TimeLine]
				   ,[SessionId])
		Select @Type 
				   ,@Comments 
				   ,@UpdatedId 
				   ,@TimeLine 
				   ,@SessionId
		Commit Transaction
		
	end try
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
    	    -- save the error in a Log file
    	    RaisError(@sError,16,1)
    	    Return  
    End Catch
	--/*------------------------------------------------------------------------------
	--	-- Return successful answer
	--	--------------------------------------------------------------------------------*/
	--	Select 'SessionId'= @SessionId_app
	--	/*-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
END