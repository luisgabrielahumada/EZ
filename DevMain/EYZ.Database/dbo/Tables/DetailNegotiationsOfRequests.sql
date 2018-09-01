CREATE TABLE [dbo].[DetailNegotiationsOfRequests] (
    [Id]                      INT              IDENTITY (1, 1) NOT NULL,
    [Token]                   UNIQUEIDENTIFIER CONSTRAINT [DF_DetailNegotiationsOfRequests_Token] DEFAULT (newid()) NULL,
    [NegotiationsOfRequestId] INT              NULL,
    [Observation]             VARCHAR (MAX)    NULL,
    [OldObservation]          VARCHAR (MAX)    NULL,
    [IsModify]                BIT              NULL,
    [IsActive]                BIT              NULL,
    [Creation]                DATETIME         CONSTRAINT [DF_DetailNegotiationsOfRequests_Creation] DEFAULT (getdate()) NULL,
    [Updated]                 DATETIME         CONSTRAINT [DF_DetailNegotiationsOfRequests_Updated] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_DetailNegotiationsOfRequests] PRIMARY KEY CLUSTERED ([Id] ASC)
);



