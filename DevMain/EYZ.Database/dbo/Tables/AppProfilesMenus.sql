CREATE TABLE [dbo].[AppProfilesMenus] (
    [ProfileMenuId]  INT      IDENTITY (1, 1) NOT NULL,
    [UpdatedId]      INT      CONSTRAINT [DF_Appprofilesmenus_id_update] DEFAULT ((1)) NOT NULL,
    [Creation]       DATETIME CONSTRAINT [DF_Appprofilesmenus_dt_creation] DEFAULT (getdate()) NOT NULL,
    [Updated]        DATETIME CONSTRAINT [DF_Appprofilesmenus_dt_updated] DEFAULT (getdate()) NOT NULL,
    [ParentId]       INT      NOT NULL,
    [IsVertical]     INT      NOT NULL,
    [IsHorizontal]   INT      NOT NULL,
    [IsActive]       BIT      NOT NULL,
    [ProfileId]      INT      NOT NULL,
    [MenuId]         INT      NOT NULL,
    [IsView]         BIT      NULL,
    [IsNew]          BIT      NULL,
    [IsEdit]         BIT      NULL,
    [IsAutorization] BIT      NULL,
    [IsStatus]       BIT      NULL,
    [IsModify]       BIT      NULL,
    [IsSpecial]      BIT      NULL,
    [IsDelete]       BIT      NULL,
    CONSTRAINT [PK_Appprofilesmenus] PRIMARY KEY CLUSTERED ([ProfileMenuId] ASC),
    CONSTRAINT [FK_Appprofilesmenus_Appmenus] FOREIGN KEY ([MenuId]) REFERENCES [dbo].[AppMenus] ([MenuId]),
    CONSTRAINT [FK_Appprofilesmenus_Appprofiles] FOREIGN KEY ([ProfileId]) REFERENCES [dbo].[AppProfiles] ([ProfileId])
);

