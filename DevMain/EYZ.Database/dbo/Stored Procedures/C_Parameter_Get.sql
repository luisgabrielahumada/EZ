CREATE PROCEDURE [dbo].[C_Parameter_Get]
	@CodeParameter [varchar](200),
	@Value [varchar](max) OUTPUT
--WITH ENCRYPTION
AS
BEGIN
	Declare  @sError Varchar(Max) 
	BEGIN TRY
	
		set @Value=(select ValueId
						from appparameters 
						where CodeParameter=@CodeParameter)
	END TRY
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
    	    Select @sError   =  ERROR_PROCEDURE() + 
					';  ' + convert(varchar,ERROR_LINE()) + 
					'; ' + ERROR_MESSAGE()
    	    -- save the error in a Log file
    	    RaisError(@sError,16,1)
    	    Return  
    End Catch

END