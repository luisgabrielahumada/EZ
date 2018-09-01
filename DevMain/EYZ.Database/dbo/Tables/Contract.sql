CREATE TABLE [dbo].[Contract] (
    [Id]            INT              IDENTITY (1, 1) NOT NULL,
    [Code]          VARCHAR (50)     NOT NULL,
    [Name]          VARCHAR (MAX)    NOT NULL,
    [Observation]   VARCHAR (MAX)    NULL,
    [AvailableFrom] DATE             NOT NULL,
    [Token]         UNIQUEIDENTIFIER CONSTRAINT [DF_Contract_Token] DEFAULT (newid()) NOT NULL,
    [Creation]      DATETIME         CONSTRAINT [DF_Contract_Creation] DEFAULT (getdate()) NULL,
    [IsActive]      BIT              NULL,
    [Updated]       DATETIME         NULL,
    [UpdatedId]     INT              NULL,
    CONSTRAINT [PK_Contract] PRIMARY KEY CLUSTERED ([Id] ASC)
);

