CREATE PROCEDURE [dbo].[App_CheckPermissionsApply_Save]
	 @UpdatedId int=0
	,@ParentId int
	,@IsVertical int
	,@IsHorizontal int
	,@IsActive int
	,@ProfileId int
	,@MenuId int
	,@IsView int
	,@IsNew int
	,@IsEdit int
	,@IsAutorization int 
	,@IsStatus int 
	,@IsModify int
	,@IsSpecial int 
	,@IsDelete int
	,@ProfileMenuId int
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
	UPDATE [dbo].[AppProfilesMenus]
	   SET [Updated] = getdate()
		  ,[ParentId] = @ParentId
		  ,[IsVertical] = @IsVertical
		  ,[IsHorizontal] = @IsHorizontal
		  ,[IsActive] = @IsActive
		  ,[ProfileId] = @ProfileId
		  ,[MenuId] = @MenuId
		  ,[IsView] = @IsView
		  ,[IsNew] = @IsNew
		  ,[IsEdit] = @IsEdit
		  ,[IsAutorization] = @IsAutorization
		  ,[IsStatus] = @IsStatus
		  ,[IsModify] = @IsModify
		  ,[IsSpecial] = @IsSpecial
		  ,[IsDelete] = @IsDelete
	 WHERE ProfileMenuId=@ProfileMenuId
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