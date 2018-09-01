CREATE PROCEDURE [dbo].[App_Menus_Save]
	@Token uniqueidentifier,
	@UpdatedId [int],
	@Menu [varchar](200),
	@Alias [varchar](200),
	@Help [text],
	@FilePage [varchar](200),
	@IsActive [int],
	@IsHorizontal [int],
	@IsVertical [int],
	@ParentId [int],
	@IsParent [int],
	@IsParentMenu [int],
	@IsAutorization [int]
--WITH ENCRYPTION
AS
BEGIN
		/*------------------------------------------------------------------------------
		-- getting xml main list only range: records_[begin,end], setting record status.
		------------------------------------------------------------------------------*/
	Declare @sError Varchar(Max) ,@IsErrorTecnichal int,@MenuId int
	Execute C_Parameter_Get @CodeParameter= 'ERROR_TECNICHAL', @Value= @IsErrorTecnichal OUTPUT
	IF Exists(Select Top 1 * From dbo.AppMenus Where FilePage=@FilePage and MenuId<>@MenuId)
	Begin
		RaisError('The duplicate key value is %s.',16,1,@FilePage)  
		return
	End
	Select @MenuId=MenuId from AppMenus where Token=@Token
	------------------------------------------------------------------------------
	-- if user is new then add it, else update it
	------------------------------------------------------------------------------
	Begin Try
	Begin Transaction
	if (Isnull(@MenuId,0)=0)
	Begin
		INSERT INTO  AppMenus(FilePage,Menu,Creation,Updated,
								ParentId,UpdatedId,IsActive,IsHorizontal,IsVertical,Help,IsParent,IsParentMenu,IsAutorization,Alias)
		VALUES(@FilePage,@Menu,getdate(),getdate(),
								(Case When @IsParent=1 Then 0 else @ParentId end),@UpdatedId,@IsActive,@IsHorizontal,@IsVertical,@Help,@IsParent,@IsParentMenu,@IsAutorization,@Alias)
								
		------------------------------------------------------------------------------
		-- send back answer
		------------------------------------------------------------------------------
		Select @MenuId= scope_identity()
		-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -		
	END
	Else
	Begin
			/*-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
			UPDATE appmenus
			SET	FilePage = @FilePage,
				Menu = @Menu,
				Alias = @Alias,
				Updated = getdate(),
				UpdatedId = @UpdatedId,
				IsActive = @IsActive,
				IsHorizontal = @IsHorizontal,
				IsVertical = @IsVertical,
				Help = @Help,
				ParentId=(Case When @IsParent=1 Then 0 else @ParentId end),
				IsParent=@IsParent,
				IsParentMenu=@IsParentMenu,
				IsAutorization=@IsAutorization
			WHERE MenuId=@MenuId
			If @@rowcount= 0
			Begin
				RaisError('SQLUPDATE_FAILD',16,1) 
			End
	End

	if not exists(Select Top 1 MenuId  From AppProfilesmenus Where MenuId=@MenuId)
	Begin
	INSERT INTO [dbo].[AppProfilesmenus]
					([UpdatedId]
					,[Creation]
					,[Updated]
					,[ParentId]
					,[IsVertical]
					,[IsHorizontal]
					,[IsActive]
					,[ProfileId]
					,[MenuId]
					,[IsView]
					,IsNew
					,IsEdit
					,IsStatus
					,IsModify)
		Select @UpdatedId
					,getdate()
					,getdate()
					,@ParentId
					,@IsVertical
					,@IsHorizontal
					,1 
					,ProfileId 
					,@MenuId
					,1
					,1
					,1
					,1
					,1
		From AppProfiles
		Where IsActive=1 and IsBlock=1
	End



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