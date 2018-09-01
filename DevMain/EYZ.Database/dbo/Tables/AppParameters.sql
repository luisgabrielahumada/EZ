CREATE TABLE [dbo].[AppParameters] (
    [ParameterId]   INT              IDENTITY (1, 1) NOT NULL,
    [CodeParameter] VARCHAR (100)    NOT NULL,
    [ValueId]       VARCHAR (MAX)    NOT NULL,
    [Parameter]     TEXT             NOT NULL,
    [IsBlocked]     BIT              NOT NULL,
    [Updated]       DATETIME         CONSTRAINT [DF_Appparameters_dt_updated] DEFAULT (getdate()) NOT NULL,
    [Creation]      DATETIME         CONSTRAINT [DF_Appparameters_dt_creation] DEFAULT (getdate()) NOT NULL,
    [UpdatedId]     INT              CONSTRAINT [DF_Appparameters_id_update] DEFAULT ((1)) NOT NULL,
    [Control]       VARCHAR (50)     NULL,
    [Observation]   VARCHAR (MAX)    NULL,
    [Type]          VARCHAR (MAX)    NULL,
    [Title]         VARCHAR (MAX)    NULL,
    [IsWidth]       INT              NULL,
    [Token]         UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK_Appparameters] PRIMARY KEY CLUSTERED ([ParameterId] ASC)
);

