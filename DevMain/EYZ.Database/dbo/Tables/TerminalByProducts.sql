CREATE TABLE [dbo].[TerminalByProducts] (
    [Id]            INT              IDENTITY (1, 1) NOT NULL,
    [Token]         UNIQUEIDENTIFIER CONSTRAINT [DF_ProductsByTerminals_Token] DEFAULT (newid()) NOT NULL,
    [TerminalId]    INT              NOT NULL,
    [ProductId]     INT              NOT NULL,
    [LoadingRate]   MONEY            NULL,
    [UnloadingRate] MONEY            NULL,
    [Creation]      DATETIME         CONSTRAINT [DF_ProductsByTerminals_Creation] DEFAULT (NULL) NULL,
    [Updated]       DATETIME         CONSTRAINT [DF_ProductsByTerminals_Updated] DEFAULT (NULL) NULL,
    [IsActive]      BIT              CONSTRAINT [DF_ProductsByTerminals_IsActive] DEFAULT ((1)) NULL,
    [UpdatedId]     INT              CONSTRAINT [DF_ProductsByTerminals_UpdatedId] DEFAULT (NULL) NOT NULL,
    CONSTRAINT [PK_ProductsByTerminals] PRIMARY KEY CLUSTERED ([Id] ASC)
);



