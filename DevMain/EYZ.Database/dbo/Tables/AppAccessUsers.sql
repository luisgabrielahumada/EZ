CREATE TABLE [dbo].[AppAccessUsers] (
    [UserAcces]      INT      IDENTITY (1, 1) NOT NULL,
    [UserId]         INT      NULL,
    [ProfileId]      INT      NULL,
    [MenuId]         INT      NOT NULL,
    [IsView]         BIT      NULL,
    [IsEdit]         BIT      NULL,
    [IsAutorization] BIT      NULL,
    [IsStatus]       BIT      NULL,
    [IsNew]          BIT      NULL,
    [IsModify]       BIT      NULL,
    [IsSpecial]      BIT      NULL,
    [Updated]        DATETIME CONSTRAINT [DF_AppAccessUsers_dt_updated] DEFAULT (getdate()) NULL,
    [Creation]       DATETIME CONSTRAINT [DF_AppAccessUsers_dt_creation] DEFAULT (getdate()) NULL,
    [UpdatedId]      INT      NULL,
    [IsDelete]       BIT      NULL,
    CONSTRAINT [PK_AppAccessUsers_1] PRIMARY KEY CLUSTERED ([UserAcces] ASC)
);

