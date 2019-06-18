CREATE TABLE [dbo].[ROLE_PERMISSION] (
    [ID]         BIGINT IDENTITY (1, 1) NOT NULL,
    [MenuID]     BIGINT NULL,
    [RoleID]     BIGINT NULL,
    [B_Add]      BIT    NULL,
    [B_Edit]     BIT    NULL,
    [B_Delete]   BIT    NULL,
    [B_View]     BIT    NULL,
    [B_Payment]  BIT    NULL,
    [Prient]     BIT    NULL,
    [Status]     BIT    NULL,
    [Company_Id] INT    NULL,
    [Branch_Id]  INT    NULL,
    CONSTRAINT [PK_UserPermission] PRIMARY KEY CLUSTERED ([ID] ASC)
);

