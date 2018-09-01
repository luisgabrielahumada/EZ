CREATE TABLE [dbo].[AppConfigurationSmtp] (
    [ConfigurationSmtpId] INT              IDENTITY (1, 1) NOT NULL,
    [Host]                VARCHAR (250)    NULL,
    [UserEmail]           VARCHAR (250)    NULL,
    [PasswordEmail]       VARCHAR (250)    NULL,
    [Port]                INT              NULL,
    [IsSsl]               BIT              NULL,
    [UpdatedId]           INT              NULL,
    [Updated]             DATETIME         CONSTRAINT [DF_AppConfigurationSendEmail_dt_updated] DEFAULT (getdate()) NULL,
    [Creation]            DATETIME         CONSTRAINT [DF_AppConfigurationSendEmail_dt_creation] DEFAULT (getdate()) NULL,
    [IsActive]            BIT              CONSTRAINT [DF_AppConfigurationSendEmail_in_active] DEFAULT ((1)) NULL,
    [IsHtml]              BIT              NULL,
    [Token]               UNIQUEIDENTIFIER CONSTRAINT [DF_AppConfigurationSmtp_ds_token] DEFAULT (newid()) NULL,
    CONSTRAINT [PK_AppConfigurationSendEmail] PRIMARY KEY CLUSTERED ([ConfigurationSmtpId] ASC)
);

