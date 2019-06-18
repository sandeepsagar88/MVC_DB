CREATE TABLE [dbo].[Companies] (
    [CompanyId]    INT            IDENTITY (1, 1) NOT NULL,
    [CompanayName] NVARCHAR (255) NULL,
    [FullAddress]  NVARCHAR (255) NULL,
    [CountryCode]  NVARCHAR (10)  NULL,
    [MobileNo]     NVARCHAR (50)  NULL,
    [PhoneNo]      NVARCHAR (50)  NULL,
    [Email]        NVARCHAR (50)  NULL,
    [WebsiteURL]   NVARCHAR (100) NULL,
    [Logo]         NVARCHAR (255) NULL,
    [CEOName]      NVARCHAR (255) NULL,
    [CountryID]    INT            NULL,
    [StateID]      INT            NULL,
    [City]         NVARCHAR (255) NULL,
    [ComapanyType] NVARCHAR (255) NULL,
    [Password]     NVARCHAR (255) NULL,
    [CreatedBy]    INT            NULL,
    [CreatedOn]    DATETIME       NULL,
    [IsActive]     BIT            NULL,
    PRIMARY KEY CLUSTERED ([CompanyId] ASC)
);

