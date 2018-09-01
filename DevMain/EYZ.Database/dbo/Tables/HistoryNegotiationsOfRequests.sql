CREATE TABLE [dbo].[HistoryNegotiationsOfRequests] (
    [Id]                      INT              NOT NULL,
    [Token]                   UNIQUEIDENTIFIER CONSTRAINT [DF_HistoryNegotiationsOfRequests_Token] DEFAULT (newid()) NULL,
    [NegotiationsOfRequestId] INT              NULL,
    [Observation]             VARCHAR (MAX)    NULL,
    [Version]                 INT              IDENTITY (1, 1) NOT NULL,
    [IsModify]                BIT              NULL,
    [IsActive]                BIT              NULL,
    [Creation]                DATETIME         CONSTRAINT [DF_HistoryNegotiationsOfRequests_Creation] DEFAULT (getdate()) NULL,
    [Updated]                 DATETIME         CONSTRAINT [DF_HistoryNegotiationsOfRequests_Updated] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_HistoryNegotiationsOfRequests] PRIMARY KEY CLUSTERED ([Id] ASC)
);



