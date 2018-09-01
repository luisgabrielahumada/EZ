CREATE TABLE [dbo].[AppUploads] (
    [UploadId]  INT              IDENTITY (1, 1) NOT NULL,
    [Upload]    VARCHAR (50)     NULL,
    [Body]      VARBINARY (MAX)  NULL,
    [UpdatedId] INT              NULL,
    [Creation]  DATETIME         CONSTRAINT [DF_AppUploads_dt_creation] DEFAULT (getdate()) NULL,
    [Updated]   DATETIME         CONSTRAINT [DF_AppUploads_dt_updated] DEFAULT (getdate()) NULL,
    [Filename]  VARCHAR (250)    NULL,
    [Token]     UNIQUEIDENTIFIER CONSTRAINT [DF_AppUploads_Token] DEFAULT (newid()) NULL,
    CONSTRAINT [PK_AppUploads] PRIMARY KEY CLUSTERED ([UploadId] ASC)
);

