CREATE TABLE [dbo].[ADDRESS] (
    [id]          BIGINT         IDENTITY (1, 1) NOT NULL,
    [name]        NVARCHAR (255) NULL,
    [addressline] NVARCHAR (255) NULL,
    [city]        NVARCHAR (255) NULL,
    [district_id] INT            NULL,
    [state_id]    INT            NULL,
    [country_id]  INT            NULL,
    [pincode]     NVARCHAR (100) NULL,
    [MobileNo]    NVARCHAR (50)  NULL,
    [PhoneNo]     NVARCHAR (50)  NULL,
    [Email]       NVARCHAR (MAX) NULL,
    [Contact_id]  INT            NULL,
    [IsActive]    BIT            NULL,
    [CreatedDate] DATETIME       NULL,
    [CreatedBy]   INT            NULL,
    [UpdatedDate] DATETIME       NULL,
    [UpdatedBy]   INT            NULL,
    [Company_ID]  BIGINT         NULL,
    [Branch_ID]   BIGINT         NULL,
    [is_default]  INT            NULL
);

