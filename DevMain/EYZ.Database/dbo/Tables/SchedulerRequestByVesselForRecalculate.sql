CREATE TABLE [dbo].[SchedulerRequestByVesselForRecalculate] (
    [Id]                      INT              IDENTITY (1, 1) NOT NULL,
    [RequestToken]            UNIQUEIDENTIFIER NULL,
    [ServiceLiquidationToken] UNIQUEIDENTIFIER NULL,
    [IdAutomatic]             INT              NULL,
    [Creation]                DATETIME         CONSTRAINT [DF_SchedulerRequestByVesselForRecalculate_Creation] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_SchedulerRequestByVesselForRecalculate] PRIMARY KEY CLUSTERED ([Id] ASC)
);

