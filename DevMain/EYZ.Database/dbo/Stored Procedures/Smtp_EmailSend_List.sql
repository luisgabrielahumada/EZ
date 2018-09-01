CREATE Procedure [dbo].[Smtp_EmailSend_List]
		@EntityId int=0
--With Encryption
As
	/*------------------------------------------------------------------------------
	-- getting xml main list only range: records_[begin,end], setting record status.
	------------------------------------------------------------------------------*/
	Declare @Uri_paremters varchar(200)
	Execute C_Parameter_Get @CodeParameter= 'URL_HOST', @Value= @Uri_paremters OUTPUT
	------------------------------------------------------------------------------
	-- Declaring variables
	------------------------------------------------------------------------------
			SELECT [EntityId]
				  ,[ToEmail]
				  ,[Subject]
				  ,dbo.AppSendEmail.[Body]
				  ,[StatusSend]
				  ,[EmailAdmin]
				  ,[Host]
				  ,[UserEmail]
				  ,[PasswordEmail]
				  ,[Port]
				  ,[IsSsl]
				  ,[IsHtml]
				  ,EmailAdmin
				  ,@Uri_paremters as Uri
				 /* ,AppUsers.Name
				  ,AppUsers.Login
				  ,AppUsers.Email*/
				  ,AppEmailBody.EmailTo
				  ,AppEmailBody.Body as Title
			FROM [dbo].[AppSendEmail]
			Cross JOIN dbo.AppConfigurationSmtp
			left Join AppUploads On AppUploads.Upload=EmailTo
			inner Join AppEmailBody On AppEmailBody.EmailTo=dbo.AppSendEmail.EmailTo
			--Inner Join AppUsers On AppUsers.UserId=[AppSendEmail].UpdatedId
			Where dbo.AppSendEmail.StatusSend='PROCESS' and dbo.AppConfigurationSmtp.IsActive=1
					And (EntityId=@EntityId or isnull(@EntityId,0)=0)