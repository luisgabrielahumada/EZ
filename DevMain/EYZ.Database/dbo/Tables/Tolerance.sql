CREATE TABLE [dbo].[Tolerance] (
    [Id]        INT              IDENTITY (1, 1) NOT NULL,
    [Token]     UNIQUEIDENTIFIER CONSTRAINT [DF__Tolerance__Id__3D5E1FD2] DEFAULT (newid()) NOT NULL,
    [Name]      VARCHAR (25)     CONSTRAINT [DF__Tolerance__Name__3E52440B] DEFAULT (NULL) NULL,
    [Value]     INT              CONSTRAINT [DF__Tolerance__Value__3F466844] DEFAULT (NULL) NULL,
    [Creation]  DATETIME         CONSTRAINT [DF__Tolerance__Creat__403A8C7D] DEFAULT (getdate()) NULL,
    [Updated]   DATETIME         CONSTRAINT [DF__Tolerance__Updat__412EB0B6] DEFAULT (NULL) NULL,
    [IsActive]  BIT              CONSTRAINT [DF__Tolerance__IsAct__4222D4EF] DEFAULT ((1)) NULL,
    [UpdatedId] INT              CONSTRAINT [DF__Tolerance__Updat__4316F928] DEFAULT (NULL) NOT NULL,
    CONSTRAINT [PK__Toleranc__3214EC07D195E9E3] PRIMARY KEY CLUSTERED ([Id] ASC)
);








GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Tolerance]
    ON [dbo].[Tolerance]([Name] ASC);

