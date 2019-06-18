CREATE PROCEDURE [dbo].[GetCompanyList]
@Company_ID int=null
AS
BEGIN
	
	SET NOCOUNT ON;
	 BEGIN try 
          BEGIN TRANSACTION 

	select c.ID, CompanyName, CEOName, con.MobileNo, con.PhoneNo, con.Email,cnt.NAME as  Country, 
	st.NAME as State, City, CompanyType,addr.addressline as  Address, WebsiteUrl, LogoPath, c.IsActive from company as c
	inner join CONTACT as con on c.Contact_Id = con.ID
	left join ADDRESS as addr on addr.Contact_Id = c.Contact_Id
	left join COUNTRY_MASTER as cnt on cnt.id = addr.country_id
	left join STATE_MASTER as st on st.id = addr.country_id
	left join DISTRICT_MASTER as dm on dm.id = addr.district_id

	 where c.IsActive=1
	and c.ID=isnull(@company_ID,c.ID)
	and addr.is_default = 1

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