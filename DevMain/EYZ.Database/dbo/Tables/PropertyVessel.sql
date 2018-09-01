CREATE TABLE [dbo].[PropertyVessel] (
    [PropertyVesselId] INT              IDENTITY (1, 1) NOT NULL,
    [Token]            UNIQUEIDENTIFIER CONSTRAINT [DF__PropertyVess__Id__08B54D69] DEFAULT (newid()) NOT NULL,
    [Name]             VARCHAR (50)     CONSTRAINT [DF__PropertyVe__Name__09A971A2] DEFAULT (NULL) NOT NULL,
    [Code]             VARCHAR (25)     CONSTRAINT [DF__PropertyVe__Code__0A9D95DB] DEFAULT (NULL) NOT NULL,
    [Creation]         DATETIME         CONSTRAINT [DF__PropertyV__Creat__0B91BA14] DEFAULT (getdate()) NULL,
    [Updated]          DATETIME         CONSTRAINT [DF__PropertyV__Updat__0C85DE4D] DEFAULT (NULL) NULL,
    [IsActive]         BIT              CONSTRAINT [DF__PropertyV__IsAct__0D7A0286] DEFAULT ((1)) NULL,
    [UpdatedId]        INT              CONSTRAINT [DF__PropertyV__Updat__0E6E26BF] DEFAULT (NULL) NOT NULL,
    CONSTRAINT [PK__Property__3214EC07471E5FA4] PRIMARY KEY CLUSTERED ([PropertyVesselId] ASC)
);






GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_PropertyVessel]
    ON [dbo].[PropertyVessel]([Name] ASC);

