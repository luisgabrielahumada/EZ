CREATE PROCEDURE [dbo].[App_Users_Save]
	@Token uniqueidentifier,
	@Login [varchar](200),
	@RoleId [int],
	@IsActive [int],
	@Name [varchar](200),
	@Email [varchar](200),
	@ProfileId [int],
	@Password [varchar](40),
	@ParentId [int] = 0,
	@IsSysadmin int=0,
	@UpdatedId int
--WITH ENCRYPTION
AS
BEGIN
		/*------------------------------------------------------------------------------
		-- getting xml main list only range: records_[begin,end], setting record status.
		------------------------------------------------------------------------------*/
	Declare @IsErrorTecnichal int,@sError varchar(max),@ProfileParameterId int,@UserId int
	Execute C_Parameter_Get @CodeParameter= 'ERROR_TECNICHAL', @Value= @IsErrorTecnichal OUTPUT
	Execute C_Parameter_Get @CodeParameter= 'DEFAULTPROFILE', @Value= @ProfileParameterId OUTPUT



	if (Isnull(@ProfileId,0)=0)
		Select  @ProfileId=ProfileId
		From  AppProfiles
		Where AppProfiles.ProfileId=@ProfileParameterId


	Select @UserId=UserId
	from AppUsers 
	where Token=@Token

	if exists(Select * from appusers where Login=@Login and Token<>@Token)
	Begin
		Raiserror('SQLINSERT_FAILD',16,1)
		return
	End
	if Exists(Select top 1 * from AppUsers where UserId=@UpdatedId and isnull(IsSysadmin,0)=0)
	Begin
		RaisError('Usted no tiene permisos para realizar esta operacion, debe tener acceso como Super Administrador...',16,1)
		return
	End
	Begin Try
	Begin Transaction
		if (Isnull(@UserId,0)=0) 
		begin
			INSERT INTO  AppUsers(Login,Password,Creation,Updated,UpdatedId,RoleId,Email,ParentId,ProfileId,Name,IsSysadmin,Reset)
			VALUES(@Login,@Password,getdate(),getdate(),@UpdatedId,0,@Email,@ParentId,@ProfileId,@Name,@IsSysadmin,@Password)
		end
		else
		begin  
			UPDATE AppUsers
			SET	RoleId = @RoleId,
				Email = @Email,
				Updated = getdate(),
				UpdatedId = @UpdatedId,
				IsActive = @IsActive,
				ProfileId=@ProfileId,
				Login=@Login,
				Name=@Name,
				ParentId=@ParentId,
				IsSysadmin=@IsSysadmin
			WHERE Token=@Token
		End
	Commit Transaction

	Exec [App_History_Timeline_Save]
					@SessionId ='',
					@UpdatedId =@UserId,
					@Type='USERS',
					@TimeLine='REGISTER_USER',
					@Comments='Realizando procesos con el usuario'

	Exec BG_EmailQueue_Save
				 @ToEmail =@Email
				,@EmailTo ='REGISTER_USER'
				,@UpdatedId =@UserId
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
		Set @sError  =   ERROR_MESSAGE()
		if @IsErrorTecnichal=1
		Begin
			Set @sError   =  ERROR_PROCEDURE() + 
					';  ' + convert(varchar,ERROR_LINE()) + 
					'; ' + ERROR_MESSAGE()
		End 
		--Getting the error description
		RaisError (@sError,16,1)
		Return
	End Catch
END