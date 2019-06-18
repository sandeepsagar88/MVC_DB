CREATE TABLE [dbo].[ROLE] (
    [ID]          BIGINT         IDENTITY (1, 1) NOT NULL,
    [Name]        NVARCHAR (MAX) NULL,
    [Short_Name]  NVARCHAR (MAX) NULL,
    [Description] NVARCHAR (MAX) NULL,
    [IsActive]    BIT            NULL,
    [CreatedDate] DATETIME       NULL,
    [CreatedBy]   INT            NULL,
    [UpdatedDate] DATETIME       NULL,
    [UpdatedBy]   INT            NULL,
    [Company_ID]  BIGINT         NULL,
    [Branch_ID]   BIGINT         NULL,
    CONSTRAINT [PK_Tbl_Role] PRIMARY KEY CLUSTERED ([ID] ASC)
);

