-- [GetbranchList] 1
CREATE PROCEDURE [dbo].[GetbranchList]
@Company_ID   bigint
AS
BEGIN
	
	SET NOCOUNT ON;

	 BEGIN try 
          BEGIN TRANSACTION 

	select [branch].ID, [branch].[Name], [branch].[Company_ID],company.CompanyName as Company, [branch].[HODName],
	addr.MobileNo, addr.PhoneNo, addr.Email, 
	cnt.NAME as  Country, 
	st.NAME as State, addr.City, addr.addressline as Address, [branch].LogoPath, [branch].IsActive,[branch].Contact_ID 
	from [branch] 
	inner join Company on [branch].[Company_ID]=Company.ID 
	left join ADDRESS as addr on addr.Contact_Id = Company.Contact_Id
	left join COUNTRY_MASTER as cnt on cnt.id = addr.country_id
	left join STATE_MASTER as st on st.id = addr.country_id
	left join DISTRICT_MASTER as dm on dm.id = addr.district_id
	inner join CONTACT as con on con.ID = [branch].Contact_Id
	inner join ROLE as r on r.ID = con.RoleId
	where [branch].IsActive=1 and [branch].Company_ID=@Company_ID
	and addr.is_default = 1 and r.Name ='BRANCH ADMIN'

	 COMMIT 
      END try 

      BEGIN catch 
          IF @@TRANCOUNT > 0 
            DECLARE @sql NVARCHAR(max) 

          SET @sql = 'ErrorNumber : ' 
                     + CONVERT(VARCHAR, Error_number()) 
                     + ' , ErrorSeverity : ' 
                     + CONVERT(VARCHAR, Error_severity()) 
                     + '      	, ErrorState : ' 
                     + CONVERT(VARCHAR, Error_state()) 
                     + ' , ErrorProcedure : ' 
                     + CONVERT(VARCHAR, Error_procedure()) 
                     + '  , ErrorLine : ' 
                     + CONVERT(VARCHAR, Error_line()) 
                     + ' , ErrorMessage : ' 
                     + CONVERT(VARCHAR, Error_message()) 
                     + ' , Mode : "DataBase" ' 

          SELECT @sql AS CustomMessage, 
                 '1'  AS CustomErrorState 

          ROLLBACK 
		  END catch 

END