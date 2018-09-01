CREATE PROCEDURE [dbo].[App_CheckPermissionsApplyProfile_Save]
	@ProfileId int
	,@MenuId int
	,@UpdatedId int=0
	,@ParentId int=0
	,@IsVertical int=0
	,@IsHorizontal int=0
	,@IsActive int=1
	,@IsView int=1
	,@IsNew int=0
	,@IsEdit int=0
	,@IsAutorization int =0
	,@IsStatus int =0
	,@IsModify int=0
	,@IsSpecial int =0
	,@IsDelete int=0
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
			INSERT INTO [dbo].[AppProfilesMenus]
					   ([ParentId]
					   ,[IsVertical]
					   ,[IsHorizontal]
					   ,[IsActive]
					   ,[ProfileId]
					   ,[MenuId]
					   ,[IsView]
					   ,[IsNew]
					   ,[IsEdit]
					   ,[IsAutorization]
					   ,[IsStatus]
					   ,[IsModify]
					   ,[IsSpecial]
					   ,[IsDelete])
				 VALUES
					   (@ParentId 
					   ,@IsVertical 
					   ,@IsHorizontal 
					   ,@IsActive 
					   ,@ProfileId 
					   ,@MenuId 
					   ,@IsView 
					   ,@IsNew 
					   ,@IsEdit 
					   ,@IsAutorization 
					   ,@IsStatus 
					   ,@IsModify 
					   ,@IsSpecial 
					   ,@IsDelete)
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