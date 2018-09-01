CREATE TABLE [dbo].[Products] (
    [Id]              INT              IDENTITY (1, 1) NOT NULL,
    [Token]           UNIQUEIDENTIFIER CONSTRAINT [DF_Products_Token] DEFAULT (newid()) NOT NULL,
    [Name]            VARCHAR (50)     CONSTRAINT [DF_Products_Name] DEFAULT ('NULL') NOT NULL,
    [Description]     VARCHAR (450)    CONSTRAINT [DF_Table_1_Quantity] DEFAULT (NULL) NOT NULL,
    [Measure]         VARCHAR (50)     NULL,
    [MeasureQuantity] VARCHAR (50)     NULL,
    [TypeId]          INT              NOT NULL,
    [Creation]        DATETIME         CONSTRAINT [DF_Products_Creation] DEFAULT (getdate()) NULL,
    [Updated]         DATETIME         CONSTRAINT [DF_Products_Updated] DEFAULT (NULL) NULL,
    [IsActive]        BIT              CONSTRAINT [DF_Products_IsActive] DEFAULT ((1)) NOT NULL,
    [UpdatedId]       INT              CONSTRAINT [DF_Products_UpdatedId] DEFAULT (NULL) NOT NULL,
    CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED ([Id] ASC)
);










GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Products]
    ON [dbo].[Products]([Name] ASC);

