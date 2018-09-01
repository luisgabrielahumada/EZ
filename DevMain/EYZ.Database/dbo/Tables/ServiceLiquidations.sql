CREATE TABLE [dbo].[ServiceLiquidations] (
    [Id]                  INT              IDENTITY (1, 1) NOT NULL,
    [Token]               UNIQUEIDENTIFIER CONSTRAINT [DF_ServiceLiquidations_Token] DEFAULT (newid()) NOT NULL,
    [RequestForServiceId] INT              NULL,
    [VesselId]            INT              NULL,
    [PriceMT]             MONEY            NULL,
    [PriceMTNew]          MONEY            NULL,
    [Status]              VARCHAR (50)     NULL,
    [Creation]            DATETIME         CONSTRAINT [DF_ServiceLiquidations_Creation] DEFAULT (NULL) NULL,
    [Updated]             DATETIME         CONSTRAINT [DF_ServiceLiquidations_Updated] DEFAULT (NULL) NULL,
    [IsActive]            BIT              CONSTRAINT [DF_ServiceLiquidations_IsActive] DEFAULT ((1)) NULL,
    [UpdatedId]           INT              CONSTRAINT [DF_ServiceLiquidations_UpdatedId] DEFAULT (NULL) NULL,
    [CurrentPortId]       INT              NULL,
    CONSTRAINT [PK_ServiceLiquidations] PRIMARY KEY CLUSTERED ([Id] ASC)
);









