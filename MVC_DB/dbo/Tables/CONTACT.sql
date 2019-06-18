CREATE TABLE [dbo].[CONTACT] (
    [ID]          BIGINT         IDENTITY (1, 1) NOT NULL,
    [Name]        NVARCHAR (MAX) NULL,
    [RoleId]      INT            NULL,
    [MobileNo]    NVARCHAR (50)  NULL,
    [PhoneNo]     NVARCHAR (50)  NULL,
    [Email]       NVARCHAR (MAX) NULL,
    [Password]    NVARCHAR (MAX) NULL,
    [Gender]      NVARCHAR (100) NULL,
    [IsActive]    BIT            NULL,
    [CreatedDate] DATETIME       NULL,
    [CreatedBy]   INT            NULL,
    [UpdatedDate] DATETIME       NULL,
    [UpdatedBy]   INT            NULL,
    [Company_ID]  BIGINT         NULL,
    [Branch_ID]   BIGINT         NULL
);

