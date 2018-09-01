CREATE TABLE [dbo].[AppSessions] (
    [Session]       INT              IDENTITY (1, 1) NOT NULL,
    [SessionId]     VARCHAR (200)    NOT NULL,
    [Creation]      DATETIME         CONSTRAINT [DF_Appsessions_dt_creation] DEFAULT (getdate()) NOT NULL,
    [Updated]       DATETIME         CONSTRAINT [DF_Appsessions_dt_updated] DEFAULT (getdate()) NOT NULL,
    [ExpirateTrace] DATETIME         NULL,
    [UpdatedId]     INT              CONSTRAINT [DF_Appsessions_id_updated] DEFAULT ((1)) NOT NULL,
    [IsTrace]       BIT              NULL,
    [UserId]        INT              NULL,
    [Token]         UNIQUEIDENTIFIER CONSTRAINT [DF_AppSessions_Token] DEFAULT (newid()) NULL,
    CONSTRAINT [PK_Appsessions] PRIMARY KEY CLUSTERED ([Session] ASC)
);

