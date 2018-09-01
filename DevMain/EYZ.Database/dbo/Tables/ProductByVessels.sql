CREATE TABLE [dbo].[ProductByVessels] (
    [Id]        INT              IDENTITY (1, 1) NOT NULL,
    [Token]     UNIQUEIDENTIFIER CONSTRAINT [DF_ProductByVessels_Token] DEFAULT (newid()) NOT NULL,
    [VesselId]  INT              NOT NULL,
    [ProductId] INT              NOT NULL,
    [Creation]  DATETIME         CONSTRAINT [DF_ProductByVessels_Creation] DEFAULT (NULL) NULL,
    [Updated]   DATETIME         CONSTRAINT [DF_ProductByVessels_Updated] DEFAULT (NULL) NULL,
    [IsActive]  BIT              CONSTRAINT [DF_ProductByVessels_IsActive] DEFAULT ((1)) NULL,
    [UpdatedId] INT              CONSTRAINT [DF_ProductByVessels_UpdatedId] DEFAULT (NULL) NOT NULL,
    CONSTRAINT [PK_ProductByVessels] PRIMARY KEY CLUSTERED ([Id] ASC)
);



