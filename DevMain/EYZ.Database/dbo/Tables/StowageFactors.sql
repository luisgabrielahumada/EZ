CREATE TABLE [dbo].[StowageFactors] (
    [Id]        INT              IDENTITY (1, 1) NOT NULL,
    [Token]     UNIQUEIDENTIFIER CONSTRAINT [DF__StowageFacto__Id__2B3F6F97] DEFAULT (newid()) NOT NULL,
    [Name]      VARCHAR (100)    CONSTRAINT [DF__StowageFac__Name__2D27B809] DEFAULT ('NULL') NOT NULL,
    [Value]     FLOAT (53)       CONSTRAINT [DF__StowageFa__Value__2E1BDC42] DEFAULT (NULL) NOT NULL,
    [Creation]  DATETIME         CONSTRAINT [DF__StowageFa__Creat__2F10007B] DEFAULT (getdate()) NULL,
    [Updated]   DATETIME         CONSTRAINT [DF__StowageFa__Updat__300424B4] DEFAULT (NULL) NULL,
    [IsActive]  BIT              CONSTRAINT [DF__StowageFa__IsAct__30F848ED] DEFAULT ((1)) NULL,
    [UpdatedId] INT              CONSTRAINT [DF__StowageFa__Updat__31EC6D26] DEFAULT (NULL) NOT NULL,
    CONSTRAINT [PK_StowageFactors] PRIMARY KEY CLUSTERED ([Id] ASC)
);








GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_StowageFactors]
    ON [dbo].[StowageFactors]([Value] ASC, [Name] ASC);

