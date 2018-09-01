CREATE TABLE [dbo].[ConditionByPorts] (
    [Id]          INT              IDENTITY (1, 1) NOT NULL,
    [Token]       UNIQUEIDENTIFIER CONSTRAINT [DF_ConditionByPorts_Token] DEFAULT (newid()) NOT NULL,
    [PortId]      INT              NULL,
    [ConditionId] INT              NULL,
    [Creation]    DATETIME         CONSTRAINT [DF_ConditionByPorts_Creation] DEFAULT (NULL) NULL,
    [Updated]     DATETIME         CONSTRAINT [DF_ConditionByPorts_Updated] DEFAULT (NULL) NULL,
    [IsActive]    BINARY (1)       CONSTRAINT [DF_ConditionByPorts_IsActive] DEFAULT ((1)) NULL,
    [UpdatedId]   INT              CONSTRAINT [DF_ConditionByPorts_UpdatedId] DEFAULT (NULL) NULL,
    CONSTRAINT [PK_ConditionByPorts] PRIMARY KEY CLUSTERED ([Id] ASC)
);

