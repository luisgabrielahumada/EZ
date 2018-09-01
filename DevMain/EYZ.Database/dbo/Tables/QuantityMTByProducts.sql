CREATE TABLE [dbo].[QuantityMTByProducts] (
    [Id]           INT              IDENTITY (1, 1) NOT NULL,
    [Token]        UNIQUEIDENTIFIER CONSTRAINT [DF_QuantityMTByProducts_Token] DEFAULT (newid()) NOT NULL,
    [ProductId]    INT              NOT NULL,
    [QuantityMTId] INT              NOT NULL,
    [Creation]     DATETIME         CONSTRAINT [DF_QuantityMTByProducts_Creation] DEFAULT (getdate()) NULL,
    [Updated]      DATETIME         CONSTRAINT [DF_QuantityMTByProducts_Updated] DEFAULT (NULL) NULL,
    [IsActive]     BIT              CONSTRAINT [DF_QuantityMTByProducts_IsActive] DEFAULT ((1)) NULL,
    [UpdatedId]    INT              CONSTRAINT [DF_QuantityMTByProducts_UpdatedId] DEFAULT (NULL) NOT NULL,
    CONSTRAINT [PK_QuantityMTByProducts] PRIMARY KEY CLUSTERED ([Id] ASC)
);





