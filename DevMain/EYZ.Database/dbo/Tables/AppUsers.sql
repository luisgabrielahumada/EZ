CREATE TABLE [dbo].[AppUsers] (
    [UserId]     INT              IDENTITY (1, 1) NOT NULL,
    [Name]       VARCHAR (200)    NULL,
    [Login]      VARCHAR (50)     NOT NULL,
    [Password]   VARCHAR (100)    NOT NULL,
    [Creation]   DATETIME         CONSTRAINT [DF_Appusers_dt_creation] DEFAULT (getdate()) NOT NULL,
    [Updated]    DATETIME         CONSTRAINT [DF_Appusers_dt_updated] DEFAULT (getdate()) NOT NULL,
    [UpdatedId]  INT              CONSTRAINT [DF_Appusers_id_update] DEFAULT ((1)) NOT NULL,
    [RoleId]     INT              NOT NULL,
    [Email]      VARCHAR (200)    NOT NULL,
    [IsActive]   BIT              CONSTRAINT [DF_AppUsers_in_active] DEFAULT ((1)) NOT NULL,
    [ParentId]   INT              NOT NULL,
    [ProfileId]  INT              NOT NULL,
    [Expiration] SMALLDATETIME    NULL,
    [Password2]  VARCHAR (100)    NULL,
    [IsSysadmin] BIT              NULL,
    [IsBlock]    BIT              CONSTRAINT [DF_AppUsers_in_block] DEFAULT ((0)) NULL,
    [Reset]      VARCHAR (250)    NULL,
    [Token]      UNIQUEIDENTIFIER CONSTRAINT [DF_AppUsers_ds_token] DEFAULT (newid()) NULL,
    CONSTRAINT [PK_Appusers] PRIMARY KEY CLUSTERED ([UserId] ASC),
    CONSTRAINT [FK_Appusers_Appprofiles] FOREIGN KEY ([ProfileId]) REFERENCES [dbo].[AppProfiles] ([ProfileId])
);

