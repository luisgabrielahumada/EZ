CREATE TABLE [dbo].[RequestForServices] (
    [Id]                   INT              IDENTITY (1, 1) NOT NULL,
    [Token]                UNIQUEIDENTIFIER CONSTRAINT [DF_RequestForServices_Token] DEFAULT (newid()) NULL,
    [ProductId]            INT              NULL,
    [StowageFactorId]      INT              NULL,
    [StowageFactor]        FLOAT (53)       NULL,
    [Creation]             DATETIME         CONSTRAINT [DF_RequestForServices_Creation] DEFAULT (NULL) NULL,
    [QuantityId]           INT              NULL,
    [Quantity]             FLOAT (53)       NULL,
    [ToleranceId]          INT              NULL,
    [Terms]                INT              NULL,
    [ConditionId]          INT              NULL,
    [LoadPortId]           INT              NULL,
    [LoadTerminalId]       INT              NULL,
    [LoadingRate]          MONEY            NULL,
    [DischargePortId]      INT              NULL,
    [DischargeTerminalId]  INT              NULL,
    [UnLoadingRate]        MONEY            NULL,
    [StartLaycan]          DATE             NULL,
    [EndLaycan]            DATE             NULL,
    [Status]               VARCHAR (50)     NULL,
    [IsActive]             BIT              CONSTRAINT [DF_RequestForServices_IsActive] DEFAULT ((1)) NULL,
    [Owner]                INT              NULL,
    [UpdatedId]            INT              CONSTRAINT [DF_RequestForServices_UpdatedId] DEFAULT (NULL) NOT NULL,
    [LoadingConditionId]   INT              NULL,
    [UnLoadingConditionId] INT              NULL,
    [HourCanalPanama]      FLOAT (53)       NULL,
    CONSTRAINT [PK_RequestForServices] PRIMARY KEY CLUSTERED ([Id] ASC)
);











