CREATE PROCEDURE [dbo].[App_CheckPermissionsApplyUsers_Save]
		@UserId int 
		,@ProfileId int 
		,@MenuId int 
		,@IsView int =1
		,@IsEdit int 
		,@IsAutorization int 
		,@IsStatus int 
		,@IsNew int 
		,@IsModify int 
		,@IsSpecial int 
		,@UpdatedId int=0 
		,@IsDelete int 
		,@UserAcces int
--WITH ENCRYPTION
AS
BEGIN
	/*------------------------------------------------------------------------------
	-- getting xml main list only range: records_begin,end, setting record status.
	--Sin Asignados
	------------------------------------------------------------------------------*/
	Declare @sError varchar(max),@i  int ,@IsErrorTecnichal int
	Execute C_Parameter_Get @CodeParameter= 'ERROR_TECNICHAL', @Value= @IsErrorTecnichal OUTPUT
	Begin Try
	Begin Transaction
		UPDATE [dbo].[AppAccessUsers]
		   SET [UserId] = @UserId   
			  ,[ProfileId] = @ProfileId   
			  ,[MenuId] = @MenuId   
			  ,[IsView] = @IsView   
			  ,[IsEdit] = @IsEdit   
			  ,[IsAutorization] = @IsAutorization   
			  ,[IsStatus] = @IsStatus   
			  ,[IsNew] = @IsNew                    
			  ,[IsModify] = @IsModify   
			  ,[IsSpecial] = @IsSpecial  
			  ,[Updated] = getdate()
			  ,[UpdatedId] = @UpdatedId   
			  ,[IsDelete] = @IsDelete   
		 WHERE UserAcces=@UserAcces
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