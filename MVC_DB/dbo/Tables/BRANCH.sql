CREATE TABLE [dbo].[BRANCH] (
    [ID]          BIGINT         IDENTITY (1, 1) NOT NULL,
    [Name]        NVARCHAR (MAX) NULL,
    [HODName]     NVARCHAR (MAX) NULL,
    [LogoPath]    NVARCHAR (MAX) NULL,
    [Company_ID]  INT            NULL,
    [Contact_Id]  BIGINT         NULL,
    [IsActive]    BIT            NULL,
    [CreatedDate] DATETIME       NULL,
    [CreatedBy]   INT            NULL,
    [UpdatedDate] DATETIME       NULL,
    [UpdatedBy]   INT            NULL
);

