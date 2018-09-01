CREATE TABLE [dbo].[ContractClauses] (
    [Id]         INT              IDENTITY (1, 1) NOT NULL,
    [ClauseId]   INT              NOT NULL,
    [ContractId] INT              NOT NULL,
    [Token]      UNIQUEIDENTIFIER CONSTRAINT [DF_ContractClauses_Token] DEFAULT (newid()) NULL,
    [Creation]   DATETIME         CONSTRAINT [DF_ContractClauses_Creation] DEFAULT (getdate()) NULL,
    [UpdatedId]  INT              NULL,
    CONSTRAINT [PK_ContractClauses] PRIMARY KEY CLUSTERED ([Id] ASC)
);

