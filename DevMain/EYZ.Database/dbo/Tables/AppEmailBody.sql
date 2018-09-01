CREATE TABLE [dbo].[AppEmailBody] (
    [EmailToId] INT              IDENTITY (1, 1) NOT NULL,
    [EmailTo]   VARCHAR (50)     NOT NULL,
    [Name]      VARCHAR (250)    NULL,
    [Body]      VARCHAR (MAX)    NOT NULL,
    [IsActive]  BIT              CONSTRAINT [DF_AppEmailBody_in_active] DEFAULT ((1)) NULL,
    [Creation]  DATETIME         CONSTRAINT [DF_AppEmailBody_dt_creation] DEFAULT (getdate()) NULL,
    [Updated]   DATETIME         CONSTRAINT [DF_AppEmailBody_dt_updated] DEFAULT (getdate()) NULL,
    [UpdatedId] INT              NULL,
    [Token]     UNIQUEIDENTIFIER CONSTRAINT [DF_AppEmailBody_ds_token] DEFAULT (newid()) NULL,
    CONSTRAINT [PK_AppEmailBody] PRIMARY KEY CLUSTERED ([EmailToId] ASC)
);

