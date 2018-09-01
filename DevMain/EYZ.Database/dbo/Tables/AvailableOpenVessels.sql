CREATE TABLE [dbo].[AvailableOpenVessels] (
    [Id]                INT              IDENTITY (1, 1) NOT NULL,
    [Token]             UNIQUEIDENTIFIER CONSTRAINT [DF_AvailableOpenVessels_Token] DEFAULT (newid()) NOT NULL,
    [NextOpeningOn]     DATE             NULL,
    [NextOpeningPort]   DATE             NULL,
    [VesselId]          INT              NOT NULL,
    [Capacity]          INT              NULL,
    [CurrentPortId]     INT              NOT NULL,
    [IsAvailable]       BIT              NULL,
    [Creation]          DATETIME         CONSTRAINT [DF_AvailableOpenVessels_Creation] DEFAULT (getdate()) NULL,
    [Updated]           DATETIME         CONSTRAINT [DF_AvailableOpenVessels_Updated] DEFAULT (NULL) NULL,
    [IsActive]          BIT              CONSTRAINT [DF_AvailableOpenVessels_IsActive] DEFAULT ((1)) NULL,
    [UpdatedId]         INT              CONSTRAINT [DF_AvailableOpenVessels_UpdatedId] DEFAULT (NULL) NOT NULL,
    [CurrentTerminalId] INT              NULL,
    CONSTRAINT [PK_AvailableOpenVessels] PRIMARY KEY CLUSTERED ([Id] ASC)
);









