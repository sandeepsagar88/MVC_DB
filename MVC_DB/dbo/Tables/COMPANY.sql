CREATE TABLE [dbo].[COMPANY] (
    [ID]          BIGINT         IDENTITY (1, 1) NOT NULL,
    [CompanyName] NVARCHAR (MAX) NULL,
    [CEOName]     NVARCHAR (MAX) NULL,
    [WebsiteUrl]  NVARCHAR (MAX) NULL,
    [LogoPath]    NVARCHAR (MAX) NULL,
    [Contact_Id]  BIGINT         NULL,
    [IsActive]    BIT            NULL,
    [CreatedDate] DATETIME       NULL,
    [CreatedBy]   INT            NULL,
    [UpdatedDate] DATETIME       NULL,
    [UpdatedBy]   INT            NULL,
    [CompanyType] NVARCHAR (100) NULL
);

