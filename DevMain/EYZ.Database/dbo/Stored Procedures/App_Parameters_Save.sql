CREATE PROCEDURE [dbo].[App_Parameters_Save]
		 @ParameterId int 
		,@ValueId varchar(max) 
		,@UpdatedId int=0 
--WITH ENCRYPTION
AS
BEGIN

	/*------------------------------------------------------------------------------
	-- getting xml main list only range: records_begin,end, setting record status.
	--Sin Asignados
	------------------------------------------------------------------------------*/
	Declare @sError varchar(max),@i  int ,@IsErrorTecnichal int, @Parameter varchar(200)
	Execute C_Parameter_Get @CodeParameter= 'ERROR_TECNICHAL', @Value= @IsErrorTecnichal OUTPUT
	Begin Try
	Select @Parameter=Parameter From [dbo].[AppParameters] Where ParameterId=@ParameterId
	if (Isnull(@ValueId,'')='')
	Begin
		raiserror('El valor del parametro ''%s'' no puede ser vacio.',16,1,@Parameter)
	End
	Begin Transaction
		UPDATE [dbo].[AppParameters]
		   SET[ValueId] = @ValueId
			  ,[Updated] = getdate()
			  ,[UpdatedId] = @UpdatedId
		 WHERE ParameterId=@ParameterId
	Commit Transaction
	------------------------------------------------------------------------------
	-- send back answer
	------------------------------------------------------------------------------
	-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
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
END