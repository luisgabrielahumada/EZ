CREATE TABLE [dbo].[Conditions] (
    [Id]          INT              IDENTITY (1, 1) NOT NULL,
    [Token]       UNIQUEIDENTIFIER CONSTRAINT [DF__Conditions__Id__45F365D3] DEFAULT (newid()) NOT NULL,
    [Name]        VARCHAR (25)     CONSTRAINT [DF__Conditions__Name__46E78A0C] DEFAULT (NULL) NOT NULL,
    [Value]       FLOAT (53)       NOT NULL,
    [Description] VARCHAR (250)    CONSTRAINT [DF__Condition__Descr__47DBAE45] DEFAULT (NULL) NULL,
    [Creation]    DATETIME         CONSTRAINT [DF__Condition__Creat__48CFD27E] DEFAULT (getdate()) NULL,
    [Updated]     DATETIME         CONSTRAINT [DF__Condition__Updat__49C3F6B7] DEFAULT (NULL) NULL,
    [IsActive]    BIT              CONSTRAINT [DF__Condition__IsAct__4AB81AF0] DEFAULT ((1)) NULL,
    [UpdatedId]   INT              CONSTRAINT [DF__Condition__Updat__4BAC3F29] DEFAULT (NULL) NOT NULL,
    CONSTRAINT [PK__Conditio__3214EC07D0B3A11A] PRIMARY KEY CLUSTERED ([Id] ASC)
);










GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Conditions]
    ON [dbo].[Conditions]([Name] ASC);

