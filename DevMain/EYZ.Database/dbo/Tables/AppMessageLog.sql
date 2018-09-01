CREATE TABLE [dbo].[AppMessageLog] (
    [MessageId]   INT              IDENTITY (1, 1) NOT NULL,
    [Message]     VARCHAR (MAX)    NULL,
    [Description] VARCHAR (MAX)    NULL,
    [Creation]    DATETIME         CONSTRAINT [DF_AppMessageLog_dt_creation] DEFAULT (getdate()) NULL,
    [StatusCode]  VARCHAR (50)     NULL,
    [Body]        VARCHAR (MAX)    NULL,
    [Token]       UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK_AppMessageLog] PRIMARY KEY CLUSTERED ([MessageId] ASC)
);

