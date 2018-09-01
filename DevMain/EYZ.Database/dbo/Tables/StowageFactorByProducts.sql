CREATE TABLE [dbo].[StowageFactorByProducts] (
    [Id]              INT              IDENTITY (1, 1) NOT NULL,
    [Token]           UNIQUEIDENTIFIER CONSTRAINT [DF_StowageFactorByProducts_Token] DEFAULT (newid()) NOT NULL,
    [ProductId]       INT              NOT NULL,
    [StowageFactorId] INT              NOT NULL,
    [Creation]        DATETIME         CONSTRAINT [DF_StowageFactorByProducts_Creation] DEFAULT (getdate()) NULL,
    [Updated]         DATETIME         CONSTRAINT [DF_StowageFactorByProducts_Updated] DEFAULT (NULL) NULL,
    [IsActive]        BIT              CONSTRAINT [DF_StowageFactorByProducts_IsActive] DEFAULT ((1)) NULL,
    [UpdatedId]       INT              CONSTRAINT [DF_StowageFactorByProducts_UpdatedId] DEFAULT (NULL) NOT NULL,
    CONSTRAINT [PK_StowageFactorByProducts] PRIMARY KEY CLUSTERED ([Id] ASC)
);





