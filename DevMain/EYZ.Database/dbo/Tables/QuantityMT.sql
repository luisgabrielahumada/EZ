CREATE TABLE [dbo].[QuantityMT] (
    [Id]        INT              IDENTITY (1, 1) NOT NULL,
    [Token]     UNIQUEIDENTIFIER CONSTRAINT [DF__QuantityMT__Id__34C8D9D1] DEFAULT (newid()) NOT NULL,
    [Name]      VARCHAR (25)     CONSTRAINT [DF__QuantityMT__Name__35BCFE0A] DEFAULT ('NULL') NOT NULL,
    [Quantity]  FLOAT (53)       CONSTRAINT [DF__QuantityM__Value__36B12243] DEFAULT (NULL) NOT NULL,
    [Creation]  DATETIME         CONSTRAINT [DF__QuantityM__Creat__37A5467C] DEFAULT (getdate()) NULL,
    [Updated]   DATETIME         CONSTRAINT [DF__QuantityM__Updat__38996AB5] DEFAULT (NULL) NULL,
    [IsActive]  BIT              CONSTRAINT [DF__QuantityM__IsAct__398D8EEE] DEFAULT ((1)) NULL,
    [UpdatedId] INT              CONSTRAINT [DF__QuantityM__Updat__3A81B327] DEFAULT (NULL) NOT NULL,
    CONSTRAINT [PK__Quantity__3214EC0765506316] PRIMARY KEY CLUSTERED ([Id] ASC)
);










GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_QuantityMT]
    ON [dbo].[QuantityMT]([Name] ASC, [Quantity] ASC);

