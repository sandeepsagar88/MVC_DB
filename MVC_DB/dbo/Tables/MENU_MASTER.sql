CREATE TABLE [dbo].[MENU_MASTER] (
    [ID]           BIGINT         IDENTITY (1, 1) NOT NULL,
    [MenuName]     NVARCHAR (50)  NULL,
    [ParentID]     BIGINT         NULL,
    [Description]  NVARCHAR (256) NULL,
    [Url]          NVARCHAR (256) NULL,
    [Icon]         NVARCHAR (50)  NULL,
    [Created_By]   NVARCHAR (256) NULL,
    [Created_Date] DATETIME       NULL,
    [Updated_By]   NVARCHAR (256) NULL,
    [Updated_Date] DATETIME       NULL,
    [Status]       BIT            NULL,
    [SL_NO]        INT            NULL,
    CONSTRAINT [PK_MenuMaster] PRIMARY KEY CLUSTERED ([ID] ASC)
);

