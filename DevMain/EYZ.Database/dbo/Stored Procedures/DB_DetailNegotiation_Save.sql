-- =============================================
-- Author:      <Author, , Name>
-- Create Date: <Create Date, , >
-- Description: <Description, , >
-- =============================================
CREATE PROCEDURE [dbo].[DB_DetailNegotiation_Save]
(
    -- Add the parameters for the stored procedure here
	@Id int,
    @NegotiationsOfRequestId int,
    @observation varchar(max),
    @IsModify bit,
    @IsActive bit,
	@UpdatedId int
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON
	Declare  @sError  Varchar(Max)  ,@IsErrorTecnichal int,@ServiceLiquidationId int,@OldObservation varchar(max)
	Execute C_Parameter_Get @CodeParameter= 'ERROR_TECNICHAL', @Value= @IsErrorTecnichal OUTPUT
	Begin Try
	Begin Transaction
	if Not exists(Select top 1 Id from DetailNegotiationsOfRequests Where NegotiationsOfRequestId=@NegotiationsOfRequestId)
	Begin
	  INSERT INTO [dbo].[DetailNegotiationsOfRequests]
				   ([NegotiationsOfRequestId]
				   ,[Observation]
				   ,[IsModify]
				   ,[IsActive])
			 VALUES
				   (@NegotiationsOfRequestId
				   ,@Observation
				   ,@IsModify
				   ,@IsActive)
	End
	else
	Begin
		Select @OldObservation=Observation
		From  DetailNegotiationsOfRequests
		Where Id=@Id

		Update DetailNegotiationsOfRequests
		Set Observation=@observation,
		    OldObservation=@OldObservation,
			Updated=getdate()
		Where Id=@Id

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
		Set @sError  =   ERROR_MESSAGE()
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