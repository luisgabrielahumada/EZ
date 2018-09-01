CREATE TABLE [dbo].[AppProfiles] (
    [ProfileId] INT              IDENTITY (1, 1) NOT NULL,
    [Profile]   VARCHAR (45)     NOT NULL,
    [Section]   VARCHAR (25)     NOT NULL,
    [IsActive]  BIT              NOT NULL,
    [Creation]  DATETIME         CONSTRAINT [DF_Appprofiles_dt_creation] DEFAULT (getdate()) NOT NULL,
    [Updated]   DATETIME         CONSTRAINT [DF_Appprofiles_dt_updated] DEFAULT (getdate()) NOT NULL,
    [UpdatedId] INT              CONSTRAINT [DF_Appprofiles_id_update] DEFAULT ((1)) NOT NULL,
    [IsBlock]   BIT              NULL,
    [Token]     UNIQUEIDENTIFIER CONSTRAINT [DF_AppProfiles_ds_token] DEFAULT (newid()) NULL,
    CONSTRAINT [PK_Appprofiles] PRIMARY KEY CLUSTERED ([ProfileId] ASC)
);

