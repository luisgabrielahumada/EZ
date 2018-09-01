CREATE TABLE [dbo].[DistanceBetweenPorts] (
    [Id]              INT              IDENTITY (1, 1) NOT NULL,
    [Token]           UNIQUEIDENTIFIER CONSTRAINT [DF_DistanceBetweenPorts_Token] DEFAULT (newid()) NOT NULL,
    [InputPortId]     INT              NOT NULL,
    [OutPutPortId]    INT              NOT NULL,
    [Interval]        FLOAT (53)       NOT NULL,
    [Updated]         DATETIME         NULL,
    [Created]         DATETIME         CONSTRAINT [DF_DistanceBetweenPorts_Created] DEFAULT (getdate()) NOT NULL,
    [IsActive]        BIT              CONSTRAINT [DF_DistanceBetweenPorts_IsActive] DEFAULT ((1)) NOT NULL,
    [UpdatedId]       INT              NOT NULL,
    [HourCanalPanama] FLOAT (53)       NULL,
    CONSTRAINT [PK_DistanceBetweenPorts] PRIMARY KEY CLUSTERED ([Id] ASC)
);



