CREATE TABLE [dbo].[Clauses] (
    [Id]        INT              IDENTITY (1, 1) NOT NULL,
    [Token]     UNIQUEIDENTIFIER CONSTRAINT [DF_Clauses_Token] DEFAULT (newid()) NOT NULL,
    [Code]      VARCHAR (50)     NOT NULL,
    [Name]      VARCHAR (MAX)    NOT NULL,
    [IsModify]  BIT              NOT NULL,
    [Creation]  DATETIME         CONSTRAINT [DF_Clauses_Creation] DEFAULT (getdate()) NULL,
    [IsActive]  BIT              NULL,
    [Updated]   DATETIME         NULL,
    [UpdatedId] INT              NULL,
    CONSTRAINT [PK_Clauses] PRIMARY KEY CLUSTERED ([Id] ASC)
);

