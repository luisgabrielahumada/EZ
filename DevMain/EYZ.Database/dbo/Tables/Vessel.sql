CREATE TABLE [dbo].[Vessel] (
    [Id]            INT              IDENTITY (1, 1) NOT NULL,
    [Token]         UNIQUEIDENTIFIER CONSTRAINT [DF__Vessel__Id__75A278F5] DEFAULT (newid()) NOT NULL,
    [Name]          VARCHAR (25)     CONSTRAINT [DF__Vessel__Name__76969D2E] DEFAULT (NULL) NOT NULL,
    [Description]   VARCHAR (250)    CONSTRAINT [DF__Vessel__Descript__778AC167] DEFAULT (NULL) NULL,
    [Phone]         VARCHAR (25)     CONSTRAINT [DF__Vessel__Phone__787EE5A0] DEFAULT (NULL) NULL,
    [Email]         VARCHAR (80)     NULL,
    [Contact]       VARCHAR (50)     NULL,
    [CityId]        INT              NOT NULL,
    [Speed]         FLOAT (53)       NULL,
    [TypeId]        INT              NULL,
    [Capacity]      INT              NULL,
    [Demurrage]     MONEY            NULL,
    [RateLoading]   MONEY            NULL,
    [RateUnloading] MONEY            NULL,
    [IfoConsumed]   MONEY            NULL,
    [MgoConsumed]   MONEY            NULL,
    [Creation]      DATETIME         CONSTRAINT [DF__Vessel__Creation__797309D9] DEFAULT (getdate()) NOT NULL,
    [Updated]       DATETIME         CONSTRAINT [DF__Vessel__Updated__7A672E12] DEFAULT (NULL) NULL,
    [IsActive]      BIT              CONSTRAINT [DF__Vessel__IsActive__7B5B524B] DEFAULT ((1)) NULL,
    [Owner]         INT              NOT NULL,
    [UpdatedId]     INT              CONSTRAINT [DF__Vessel__UpdatedI__7C4F7684] DEFAULT (NULL) NOT NULL,
    CONSTRAINT [PK__Vessel__3214EC074E5D2BD9] PRIMARY KEY CLUSTERED ([Id] ASC)
);












GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Vessel]
    ON [dbo].[Vessel]([Name] ASC);

