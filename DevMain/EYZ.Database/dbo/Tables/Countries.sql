CREATE TABLE [dbo].[Countries] (
    [CountryId]         INT              IDENTITY (1, 1) NOT NULL,
    [Country]           VARCHAR (50)     NOT NULL,
    [CodeInternational] VARCHAR (50)     NULL,
    [Code]              VARCHAR (50)     NULL,
    [UpdatedId]         INT              NOT NULL,
    [Updated]           DATETIME         CONSTRAINT [DF_Countries_dt_updated] DEFAULT (getdate()) NOT NULL,
    [Created]           DATETIME         CONSTRAINT [DF_Countries_dt_created] DEFAULT (getdate()) NOT NULL,
    [IsActive]          BIT              CONSTRAINT [DF_Countries_in_active] DEFAULT ((1)) NOT NULL,
    [Token]             UNIQUEIDENTIFIER CONSTRAINT [DF_Countries_ds_token] DEFAULT (newid()) NULL,
    CONSTRAINT [PK_Countries] PRIMARY KEY CLUSTERED ([CountryId] ASC)
);






GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Countries]
    ON [dbo].[Countries]([Country] ASC);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The duplicate key value on Countries', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Countries', @level2type = N'INDEX', @level2name = N'IX_Countries';

