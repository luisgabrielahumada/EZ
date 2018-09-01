CREATE Procedure [dbo].[App_EmailSend_DashBoard_List]
		@pageIndex int,
		@pageSize int,
		@TotalRecords [int] = 0 OUTPUT
--With Encryption
As
	/*------------------------------------------------------------------------------
	-- getting xml main list only range: records_[begin,end], setting record status.
	------------------------------------------------------------------------------*/
	Select @TotalRecords=count(*) From [AppSendEmail]
	------------------------------------------------------------------------------
	-- Declaring variables
	------------------------------------------------------------------------------
				SELECT [EntityId]
					  ,[ToEmail]
					  ,[Subject]
					  ,[Body]
					  ,[StatusSend]
					  ,[EmailAdmin]
					  ,EmailTo
					  ,Creation
					  ,Updated
				FROM [dbo].[AppSendEmail]
				ORDER BY EntityId desc, CURRENT_TIMESTAMP OFFSET (@PageIndex-1)*@PageSize ROWS FETCH FIRST @PageSize ROWS ONLY