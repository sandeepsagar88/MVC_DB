CREATE TABLE [dbo].[IDMaster] (
    [id]             BIGINT         IDENTITY (1, 1) NOT NULL,
    [Name]           NVARCHAR (255) NULL,
    [Prefix]         NVARCHAR (255) NULL,
    [PrefixSeperate] NVARCHAR (255) NULL,
    [Suffix]         NVARCHAR (255) NULL,
    [SuffixSeperate] NVARCHAR (255) NULL,
    [Number]         NVARCHAR (255) NULL,
    [CreatedBy]      BIGINT         NULL,
    [CreatedOn]      DATETIME       NULL,
    [UpdateDate]     DATETIME       NULL,
    [UpdateBy]       BIGINT         NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);

