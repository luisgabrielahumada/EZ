CREATE TABLE [dbo].[RankConceptRate] (
    [Id]                 INT              IDENTITY (1, 1) NOT NULL,
    [Token]              UNIQUEIDENTIFIER CONSTRAINT [DF_RankConceptRate_Token] DEFAULT (newid()) NOT NULL,
    [RankRateTerminalId] INT              NULL,
    [Concept]            VARCHAR (250)    NULL,
    [Value]              MONEY            NULL,
    [Description]        VARCHAR (500)    NULL,
    [Creation]           DATETIME         CONSTRAINT [DF_RankConceptRate_Creation] DEFAULT (NULL) NULL,
    [Updated]            DATETIME         CONSTRAINT [DF_RankConceptRate_Updated] DEFAULT (NULL) NULL,
    [IsActive]           BIT              CONSTRAINT [DF_RankConceptRate_IsActive] DEFAULT ((1)) NULL,
    [UpdatedId]          INT              CONSTRAINT [DF_RankConceptRate_UpdatedId] DEFAULT (NULL) NULL,
    CONSTRAINT [PK_RankConceptRate] PRIMARY KEY CLUSTERED ([Id] ASC)
);

