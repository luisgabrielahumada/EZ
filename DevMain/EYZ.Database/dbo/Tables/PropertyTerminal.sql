CREATE TABLE [dbo].[PropertyTerminal] (
    [PropertyTerminalId] INT              IDENTITY (1, 1) NOT NULL,
    [Token]              UNIQUEIDENTIFIER CONSTRAINT [DF__PropertyTerm__Id__4E88ABD4] DEFAULT (newid()) NOT NULL,
    [Name]               VARCHAR (25)     CONSTRAINT [DF__PropertyTe__Name__4F7CD00D] DEFAULT (NULL) NULL,
    [Code]               VARCHAR (15)     CONSTRAINT [DF__PropertyTe__Code__5070F446] DEFAULT (NULL) NULL,
    [Creation]           DATETIME         CONSTRAINT [DF__PropertyT__Creat__5165187F] DEFAULT (getdate()) NOT NULL,
    [Updated]            DATETIME         CONSTRAINT [DF__PropertyT__Updat__52593CB8] DEFAULT (NULL) NULL,
    [IsActive]           BIT              CONSTRAINT [DF__PropertyT__IsAct__534D60F1] DEFAULT ((1)) NULL,
    [UpdatedId]          INT              CONSTRAINT [DF__PropertyT__Updat__5441852A] DEFAULT (NULL) NOT NULL,
    CONSTRAINT [PK__Property__3214EC077EA2C989] PRIMARY KEY CLUSTERED ([PropertyTerminalId] ASC)
);



