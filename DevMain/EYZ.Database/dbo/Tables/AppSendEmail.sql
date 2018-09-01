CREATE TABLE [dbo].[AppSendEmail] (
    [EntityId]   INT              IDENTITY (1, 1) NOT NULL,
    [ToEmail]    VARCHAR (MAX)    NULL,
    [Subject]    VARCHAR (250)    NULL,
    [Body]       VARCHAR (MAX)    NULL,
    [Updated]    DATETIME         CONSTRAINT [DF_AppSendEmail_dt_updated] DEFAULT (getdate()) NULL,
    [Creation]   DATETIME         CONSTRAINT [DF_AppSendEmail_dt_creation] DEFAULT (getdate()) NULL,
    [UpdatedId]  INT              NULL,
    [StatusSend] VARCHAR (50)     NULL,
    [Message]    VARCHAR (MAX)    NULL,
    [EmailAdmin] VARCHAR (MAX)    NULL,
    [EmailTo]    VARCHAR (MAX)    NULL,
    [Token]      UNIQUEIDENTIFIER CONSTRAINT [DF_AppSendEmail_Token] DEFAULT (newid()) NULL,
    CONSTRAINT [PK_AppSendEmail] PRIMARY KEY CLUSTERED ([EntityId] ASC)
);

