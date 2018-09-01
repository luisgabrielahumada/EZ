CREATE TABLE [dbo].[NegotiationsOfRequests] (
    [Id]                   INT              IDENTITY (1, 1) NOT NULL,
    [ServiceLiquidationId] INT              NULL,
    [Token]                UNIQUEIDENTIFIER CONSTRAINT [DF_NegotiationsOfRequests_Token] DEFAULT (newid()) NULL,
    [Status]               VARCHAR (25)     NULL,
    [NextAction]           VARCHAR (25)     NULL,
    [IsActive]             BIT              NULL,
    [UpdatedId]            INT              NULL,
    [Creation]             DATETIME         CONSTRAINT [DF_NegotiationsOfRequests_Creation] DEFAULT (getdate()) NULL,
    [Updated]              DATETIME         CONSTRAINT [DF_NegotiationsOfRequests_Updated] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_NegotiationsOfRequests] PRIMARY KEY CLUSTERED ([Id] ASC)
);



