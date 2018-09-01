CREATE TABLE [dbo].[AppMenus] (
    [MenuId]         INT              IDENTITY (1, 1) NOT NULL,
    [FilePage]       VARCHAR (200)    NOT NULL,
    [IsActive]       BIT              NOT NULL,
    [Creation]       DATETIME         CONSTRAINT [DF_Appmenus_dt_creation] DEFAULT (getdate()) NOT NULL,
    [Updated]        DATETIME         CONSTRAINT [DF_Appmenus_dt_updated] DEFAULT (getdate()) NOT NULL,
    [UpdatedId]      INT              CONSTRAINT [DF_Appmenus_id_update] DEFAULT ((1)) NOT NULL,
    [Menu]           VARCHAR (200)    NOT NULL,
    [ParentId]       INT              NOT NULL,
    [Help]           TEXT             NULL,
    [IsVertical]     INT              NOT NULL,
    [IsHorizontal]   INT              NOT NULL,
    [IsParent]       BIT              NULL,
    [IsParentMenu]   BIT              NULL,
    [IsAutorization] BIT              NULL,
    [Icon]           VARCHAR (50)     NULL,
    [Token]          UNIQUEIDENTIFIER CONSTRAINT [DF_AppMenus_ds_token] DEFAULT (newid()) NULL,
    [Alias]          VARCHAR (200)    NULL,
    CONSTRAINT [PK_Appmenus] PRIMARY KEY CLUSTERED ([MenuId] ASC)
);



