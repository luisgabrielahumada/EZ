CREATE TABLE [dbo].[ItemsLiquidation] (
    [Id]                         INT              IDENTITY (1, 1) NOT NULL,
    [Token]                      UNIQUEIDENTIFIER CONSTRAINT [DF_ItemsLiquidation_Token] DEFAULT (newid()) NOT NULL,
    [ServiceLiquidationId]       INT              NULL,
    [Route]                      VARCHAR (250)    NULL,
    [VesselId]                   INT              NULL,
    [CurrentPortAtLoadPort]      MONEY            NULL,
    [LoadingPort]                MONEY            NULL,
    [CanalPanama]                MONEY            NULL,
    [LoadPortAtUnloadingPort]    MONEY            NULL,
    [UnLoadPort]                 MONEY            NULL,
    [IsPrice]                    INT              NULL,
    [Creation]                   DATETIME         CONSTRAINT [DF_ItemsLiquidation_Creation] DEFAULT (NULL) NULL,
    [Updated]                    DATETIME         CONSTRAINT [DF_ItemsLiquidation_Updated] DEFAULT (NULL) NULL,
    [IsActive]                   BIT              CONSTRAINT [DF_ItemsLiquidation_IsActive] DEFAULT ((1)) NULL,
    [UpdatedId]                  INT              CONSTRAINT [DF_ItemsLiquidation_UpdatedId] DEFAULT (NULL) NULL,
    [CurrentPortId]              INT              NULL,
    [LoadingPortId]              INT              NULL,
    [UnLoadingPortId]            INT              NULL,
    [Type]                       VARCHAR (50)     NULL,
    [CanalPanamaDischarge]       FLOAT (53)       NULL,
    [IsCurrentPort]              BIT              DEFAULT ((1)) NULL,
    [ValueLoadingCondition]      MONEY            DEFAULT ((0)) NULL,
    [ValueUnLoadingCondition]    MONEY            DEFAULT ((0)) NULL,
    [VesselSpeed]                FLOAT (53)       DEFAULT ((0)) NULL,
    [VesselCapacity]             FLOAT (53)       DEFAULT ((0)) NULL,
    [VesselIfoConsumed]          MONEY            DEFAULT ((0)) NULL,
    [VesselMgoConsumed]          MONEY            DEFAULT ((0)) NULL,
    [RateLoading]                MONEY            DEFAULT ((0)) NULL,
    [CurrentFirstInterval]       FLOAT (53)       DEFAULT ((0)) NULL,
    [HourCanalPanama]            FLOAT (53)       DEFAULT ((0)) NULL,
    [DayCurrentPortAtLoadPort]   FLOAT (53)       DEFAULT ((0)) NULL,
    [Quantity]                   FLOAT (53)       DEFAULT ((0)) NULL,
    [LoadingRate]                MONEY            DEFAULT ((0)) NULL,
    [DayLoadingPort]             FLOAT (53)       DEFAULT ((0)) NULL,
    [DayCanalPanama]             FLOAT (53)       DEFAULT ((0)) NULL,
    [DayLoadPortAtUnloadingPort] FLOAT (53)       DEFAULT ((0)) NULL,
    [DayCanalPanamaDischarge]    FLOAT (53)       DEFAULT ((0)) NULL,
    [DayUnLoadingPort]           FLOAT (53)       DEFAULT ((0)) NULL,
    [IfoLoadPort]                FLOAT (53)       DEFAULT ((0)) NULL,
    [MgoLoadPort]                FLOAT (53)       DEFAULT ((0)) NULL,
    [IfoUnLoadPort]              FLOAT (53)       DEFAULT ((0)) NULL,
    [MgoUnLoadPort]              FLOAT (53)       DEFAULT ((0)) NULL,
    [RateUnLoading]              MONEY            DEFAULT ((0)) NULL,
    [CurrentInterval]            FLOAT (53)       DEFAULT ((0)) NULL,
    [UnLoadingRate]              MONEY            DEFAULT ((0)) NULL,
    [RateLoadTerminal]           FLOAT (53)       DEFAULT ((0)) NULL,
    [RateChargeTerminal]         FLOAT (53)       DEFAULT ((0)) NULL,
    CONSTRAINT [PK_ItemsLiquidation] PRIMARY KEY CLUSTERED ([Id] ASC)
);













