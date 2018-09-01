CREATE TABLE [dbo].[PropertyValueVessel] (
    [PropertyValueVesselId] INT              IDENTITY (1, 1) NOT NULL,
    [Token]                 UNIQUEIDENTIFIER CONSTRAINT [DF__PropertyValu__Id__7F2BE32F] DEFAULT (newid()) NULL,
    [VesselId]              INT              CONSTRAINT [DF__PropertyV__Vesse__00200768] DEFAULT (NULL) NOT NULL,
    [PropertyVesselId]      INT              CONSTRAINT [DF__PropertyV__Prope__01142BA1] DEFAULT (NULL) NOT NULL,
    [Value]                 VARCHAR (250)    CONSTRAINT [DF__PropertyV__Value__02084FDA] DEFAULT (NULL) NULL,
    [Creation]              DATETIME         CONSTRAINT [DF__PropertyV__Creat__02FC7413] DEFAULT (getdate()) NULL,
    [Updated]               DATETIME         CONSTRAINT [DF__PropertyV__Updat__03F0984C] DEFAULT (NULL) NULL,
    [IsActive]              BIT              CONSTRAINT [DF__PropertyV__IsAct__04E4BC85] DEFAULT ((1)) NULL,
    [UpdatedId]             INT              CONSTRAINT [DF__PropertyV__Updat__05D8E0BE] DEFAULT (NULL) NOT NULL,
    CONSTRAINT [PK__Property__3214EC07F6D2462D] PRIMARY KEY CLUSTERED ([PropertyValueVesselId] ASC),
    CONSTRAINT [FK_PropertyValueVessel_PropertyVessel] FOREIGN KEY ([PropertyVesselId]) REFERENCES [dbo].[PropertyVessel] ([PropertyVesselId]),
    CONSTRAINT [FK_PropertyValueVessel_Vessel] FOREIGN KEY ([VesselId]) REFERENCES [dbo].[Vessel] ([Id])
);





