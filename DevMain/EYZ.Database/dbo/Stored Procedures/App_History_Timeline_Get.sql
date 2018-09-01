CREATE PROCEDURE [dbo].[App_History_Timeline_Get]
	@SessionId [varchar](250),
	@UpdatedId [int],
	@Type varchar(50),
	@TimeLine varchar(50)='',
	@PageIndex int=1,
	@PageSize int=10,
	@TotalRecords [int] = 0 OUTPUT
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

		Select  @TotalRecords=count(*)  
		From  [dbo].[AppHistoryTimeline]
		Where  UpdatedId=@UpdatedId


		Select [Type]
				   ,[Comments]
				   ,[UpdatedId]
				   ,[TimeLine]
				   ,[SessionId]
				   ,Creation
				   ,convert(varchar,Creation,100) as dt_date
				   ,datediff(year,Creation,getdate()) as in_year
				   ,datediff(month,Creation,getdate()) as in_month
				   ,datediff(day,Creation,getdate()) as in_day
				   ,datediff(hour,Creation,getdate()) as in_hour
				   ,datediff(minute,Creation,getdate())as in_minute
				   ,datediff(second,Creation,getdate())as in_secound
		From  [dbo].[AppHistoryTimeline]
		Where
		--(Isnull(@SessionId,'')='' or SessionId=@SessionId) and
		UpdatedId=@UpdatedId and 
		(Isnull(@Type,'')='' or Type=@Type) and
		(Isnull(@TimeLine,'')='' or TimeLine=@TimeLine) 
		ORDER BY Creation desc, CURRENT_TIMESTAMP OFFSET (@PageIndex-1)*@PageSize ROWS FETCH FIRST @PageSize ROWS ONLY
		 
	--/*------------------------------------------------------------------------------
	--	-- Return successful answer
	--	--------------------------------------------------------------------------------*/
	--	Select 'SessionId'= @SessionId_app
	--	/*-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
END