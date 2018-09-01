CREATE TABLE [dbo].[Cities] (
    [CityId]       INT              IDENTITY (1, 1) NOT NULL,
    [CountryId]    INT              NOT NULL,
    [DepartmentId] INT              NULL,
    [City]         VARCHAR (50)     NOT NULL,
    [UpdatedId]    INT              NOT NULL,
    [Updated]      DATETIME         CONSTRAINT [DF_Cities_dt_updated] DEFAULT (getdate()) NOT NULL,
    [Created]      DATETIME         CONSTRAINT [DF_Cities_dt_created] DEFAULT (getdate()) NOT NULL,
    [IsActive]     BIT              CONSTRAINT [DF_Cities_in_active] DEFAULT ((1)) NOT NULL,
    [Token]        UNIQUEIDENTIFIER CONSTRAINT [DF_Cities_ds_token] DEFAULT (newid()) NULL,
    CONSTRAINT [PK_City] PRIMARY KEY CLUSTERED ([CityId] ASC),
    CONSTRAINT [FK_Cities_Countries] FOREIGN KEY ([CountryId]) REFERENCES [dbo].[Countries] ([CountryId])
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Cities]
    ON [dbo].[Cities]([City] ASC);

