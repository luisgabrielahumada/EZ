CREATE TABLE [dbo].[RankRateTerminals] (
    [Id]         INT              IDENTITY (1, 1) NOT NULL,
    [Token]      UNIQUEIDENTIFIER CONSTRAINT [DF_RankRateTerminals_Token] DEFAULT (newid()) NOT NULL,
    [Minimum]    INT              NOT NULL,
    [Maximum]    INT              NOT NULL,
    [Rate]       MONEY            NOT NULL,
    [TerminalId] INT              NOT NULL,
    [Creation]   DATETIME         CONSTRAINT [DF_RankRateTerminals_Creation] DEFAULT (NULL) NULL,
    [Updated]    DATETIME         CONSTRAINT [DF_RankRateTerminals_Updated] DEFAULT (NULL) NULL,
    [IsActive]   BIT              CONSTRAINT [DF_RankRateTerminals_IsActive] DEFAULT ((1)) NULL,
    [UpdatedId]  INT              CONSTRAINT [DF_RankRateTerminals_UpdatedId] DEFAULT (NULL) NOT NULL,
    CONSTRAINT [PK_RankRateTerminals] PRIMARY KEY CLUSTERED ([Id] ASC)
);



