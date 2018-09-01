CREATE TABLE [dbo].[AppHistoryTimeline] (
    [historyId] INT              IDENTITY (1, 1) NOT NULL,
    [Type]      VARCHAR (50)     NULL,
    [Creation]  DATETIME         CONSTRAINT [DF_AppHistoryTimeline_dt_creation] DEFAULT (getdate()) NULL,
    [Comments]  VARCHAR (MAX)    NULL,
    [UpdatedId] INT              NULL,
    [TimeLine]  VARCHAR (50)     NULL,
    [SessionId] VARCHAR (250)    NULL,
    [Token]     UNIQUEIDENTIFIER CONSTRAINT [DF_AppHistoryTimeline_Token] DEFAULT (newid()) NULL,
    CONSTRAINT [PK_AppHistoryTimeline] PRIMARY KEY CLUSTERED ([historyId] ASC)
);

