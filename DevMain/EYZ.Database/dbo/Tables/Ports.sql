CREATE TABLE [dbo].[Ports] (
    [Id]        INT              IDENTITY (1, 1) NOT NULL,
    [Token]     UNIQUEIDENTIFIER CONSTRAINT [DF__Ports__Id__571DF1D5] DEFAULT (newid()) NOT NULL,
    [Name]      VARCHAR (25)     CONSTRAINT [DF__Ports__Name__5812160E] DEFAULT (NULL) NULL,
    [Address]   VARCHAR (200)    CONSTRAINT [DF__Ports__Address__59063A47] DEFAULT (NULL) NULL,
    [Phone]     VARCHAR (50)     CONSTRAINT [DF__Ports__Phone__59FA5E80] DEFAULT (NULL) NULL,
    [City]      INT              CONSTRAINT [DF__Ports__City__5AEE82B9] DEFAULT (NULL) NOT NULL,
    [Ifo]       MONEY            CONSTRAINT [DF_Ports_Ifo] DEFAULT ((0)) NULL,
    [Mgo]       MONEY            CONSTRAINT [DF_Ports_Mgo] DEFAULT ((0)) NULL,
    [Terms]     VARCHAR (MAX)    NULL,
    [Creation]  DATETIME         CONSTRAINT [DF__Ports__Creation__5BE2A6F2] DEFAULT (getdate()) NULL,
    [Updated]   DATETIME         CONSTRAINT [DF__Ports__Updated__5CD6CB2B] DEFAULT (NULL) NULL,
    [IsActive]  BIT              CONSTRAINT [DF__Ports__IsActive__5DCAEF64] DEFAULT ((1)) NULL,
    [UpdatedId] INT              CONSTRAINT [DF__Ports__UpdatedId__5EBF139D] DEFAULT (NULL) NOT NULL,
    [Draft]     MONEY            NULL,
    [Dwt]       MONEY            NULL,
    CONSTRAINT [PK__Ports__3214EC078307D29B] PRIMARY KEY CLUSTERED ([Id] ASC)
);










GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Ports]
    ON [dbo].[Ports]([Name] ASC);

