CREATE TABLE [dbo].[ProductTypes] (
    [ProductTypeId] INT              IDENTITY (1, 1) NOT NULL,
    [Token]         UNIQUEIDENTIFIER CONSTRAINT [DF__ProductTypes__Id__239E4DCF] DEFAULT (newid()) NOT NULL,
    [Name]          VARCHAR (100)    CONSTRAINT [DF__ProductTyp__Name__24927208] DEFAULT ('NULL') NOT NULL,
    [Code]          VARCHAR (10)     CONSTRAINT [DF__ProductTyp__Code__25869641] DEFAULT ('NULL') NOT NULL,
    [Creation]      DATETIME         CONSTRAINT [DF__ProductTy__Creat__267ABA7A] DEFAULT (NULL) NULL,
    [Updated]       DATETIME         CONSTRAINT [DF__ProductTy__Updat__276EDEB3] DEFAULT (NULL) NULL,
    [IsActive]      BINARY (1)       CONSTRAINT [DF__ProductTy__IsAct__286302EC] DEFAULT ((1)) NULL,
    [UpdatedId]     INT              CONSTRAINT [DF__ProductTy__Updat__29572725] DEFAULT (NULL) NOT NULL,
    CONSTRAINT [PK__ProductT__3214EC0763D5BA31] PRIMARY KEY CLUSTERED ([ProductTypeId] ASC)
);

