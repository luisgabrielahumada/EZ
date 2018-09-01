CREATE TABLE [dbo].[Terminals] (
    [Id]             INT              IDENTITY (1, 1) NOT NULL,
    [Token]          UNIQUEIDENTIFIER CONSTRAINT [DF__Terminals__Id__619B8048] DEFAULT (newid()) NOT NULL,
    [PortId]         INT              CONSTRAINT [DF__Terminals__PortI__628FA481] DEFAULT (NULL) NOT NULL,
    [Name]           VARCHAR (25)     CONSTRAINT [DF__Terminals__Name__6383C8BA] DEFAULT (NULL) NULL,
    [Address]        VARCHAR (200)    CONSTRAINT [DF__Terminals__Addre__6477ECF3] DEFAULT (NULL) NULL,
    [Contants]       VARCHAR (200)    NULL,
    [CityId]         INT              NOT NULL,
    [Phone]          VARCHAR (50)     NULL,
    [Xaxis]          FLOAT (53)       NULL,
    [Yaxis]          FLOAT (53)       NULL,
    [Email]          VARCHAR (80)     CONSTRAINT [DF__Terminals__Email__656C112C] DEFAULT (NULL) NULL,
    [Creation]       DATETIME         CONSTRAINT [DF__Terminals__Creat__66603565] DEFAULT (getdate()) NULL,
    [Updated]        DATETIME         CONSTRAINT [DF__Terminals__Updat__6754599E] DEFAULT (NULL) NULL,
    [IsActive]       BIT              CONSTRAINT [DF__Terminals__IsAct__68487DD7] DEFAULT ((1)) NULL,
    [UpdatedId]      INT              CONSTRAINT [DF__Terminals__Updat__693CA210] DEFAULT (NULL) NOT NULL,
    [ConditionId]    INT              DEFAULT ((0)) NULL,
    [ConditionValue] FLOAT (53)       NULL,
    [_Order]         INT              DEFAULT ((0)) NULL,
    CONSTRAINT [PK__Terminal__3214EC073BCB9D5A] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Terminals_Ports] FOREIGN KEY ([PortId]) REFERENCES [dbo].[Ports] ([Id])
);












GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Terminals]
    ON [dbo].[Terminals]([Name] ASC, [PortId] ASC);

