CREATE TABLE [dbo].[PropertyValueTerminals] (
    [PropertyValueTerminalId] INT              IDENTITY (1, 1) NOT NULL,
    [Token]                   UNIQUEIDENTIFIER CONSTRAINT [DF__PropertyValu__Id__6C190EBB] DEFAULT (newid()) NOT NULL,
    [TerminalId]              INT              CONSTRAINT [DF__PropertyV__Termi__6D0D32F4] DEFAULT (NULL) NOT NULL,
    [PropertyTerminalId]      INT              CONSTRAINT [DF__PropertyV__Prope__6E01572D] DEFAULT (NULL) NOT NULL,
    [Value]                   INT              CONSTRAINT [DF__PropertyV__Value__6EF57B66] DEFAULT (NULL) NULL,
    [Creation]                DATETIME         CONSTRAINT [DF__PropertyV__Creat__6FE99F9F] DEFAULT (getdate()) NULL,
    [Updated]                 DATETIME         CONSTRAINT [DF__PropertyV__Updat__70DDC3D8] DEFAULT (NULL) NULL,
    [IsActive]                BIT              CONSTRAINT [DF__PropertyV__IsAct__71D1E811] DEFAULT ((1)) NULL,
    [UpdatedId]               INT              CONSTRAINT [DF__PropertyV__Updat__72C60C4A] DEFAULT (NULL) NOT NULL,
    CONSTRAINT [PK__Property__3214EC07D4274B9B] PRIMARY KEY CLUSTERED ([PropertyValueTerminalId] ASC),
    CONSTRAINT [FK_PropertyValueTerminals_PropertyTerminal] FOREIGN KEY ([PropertyTerminalId]) REFERENCES [dbo].[PropertyTerminal] ([PropertyTerminalId]),
    CONSTRAINT [FK_PropertyValueTerminals_Terminals] FOREIGN KEY ([TerminalId]) REFERENCES [dbo].[Terminals] ([Id])
);



