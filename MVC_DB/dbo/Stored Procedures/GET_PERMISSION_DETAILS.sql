
-- [GET_PERMISSION_DETAILS]  3,2,2
create PROCEDURE [dbo].[GET_PERMISSION_DETAILS] 
(
 @Roll_Id varchar(20)
,@BRANCH_ID bigint  =null
,@COMPANY_ID bigint =null
)
AS
BEGIN

	SET NOCOUNT ON;

	 BEGIN try 
          BEGIN TRANSACTION 

        DECLARE @TABLE_TEMP TABLE
        (
        TEMP_ID INT   IDENTITY(1,1),
        Permission_ID varchar(1056) null,
        MenuID		  varchar(1056) null,
        ParentID	  varchar(1056) null,
        RoleID		  varchar(1056) null,
        MenuName	  varchar(1056) null,
        B_Add		  varchar(1056) null,
        B_Edit		  varchar(1056) null,
        B_Delete	  varchar(1056) null,
        B_View		  varchar(1056) null,
        B_Payment	  varchar(1056) null,
        RoleName	  varchar(1056) null,
        SL_NO	      varchar(1056) null
        )

	declare @rollid varchar(20)
	declare @rollname varchar(20)
	set @rollname = (select Name from Role  where ID = @Roll_Id)
	set @rollid = (select DISTINCT RoleID from ROLE_PERMISSION where RoleID = @Roll_Id)

	IF(isnull(nullif(@rollid,''),'')='')
		BEGIN
		    INSERT INTO	@TABLE_TEMP
			SELECT '' AS Permission_ID,ID AS MenuID,ParentID,null as RoleID,MenuName AS MenuName,0 AS B_Add, 0 AS B_Edit,0 AS B_Delete,0 AS B_View,0 AS B_Payment,@rollname as RoleName,SL_NO FROM MENU_MASTER
		   
		END
	ELSE
		BEGIN
	        INSERT INTO	@TABLE_TEMP
			SELECT R.[ID] AS Permission_ID,R.[MenuID] AS MenuID,M.ParentID,R.RoleID,M.MenuName AS MenuName,R.[B_Add], R.[B_Edit],R.[B_Delete],R.[B_View],R.[B_Payment],@rollname as RoleName,M.SL_NO FROM MENU_MASTER M
            inner  JOIN ROLE_PERMISSION R on R.MenuID = M.ID  WHERE R.RoleID = @Roll_Id  AND  R.COMPANY_ID=@COMPANY_ID and R.BRANCH_ID=@BRANCH_ID 
            --UNION ALL 
            --SELECT null AS Permission_ID ,ID AS MenuID,M.ParentID,@Roll_Id as RoleID,M.MenuName AS MenuName,0 as [B_Add],0 as [B_Edit],0 as [B_Delete],0 as [B_View],0 as [B_Payment],@rollname as RoleName,M.SL_NO from MENU_MASTER M
            --WHERE M.ID NOT IN (
            --(SELECT R.[MenuID]  FROM MENU_MASTER M
            --LEFT JOIN ROLE_PERMISSION R on R.MenuID = M.ID  WHERE R.RoleID = @Roll_Id  AND  R.COMPANY_ID=@COMPANY_ID and R.BRANCH_ID=@BRANCH_ID) )
		END
		 
		
        select t1.ID as MenuID, case 
        when  t1.Url='#' or t1.Url='' or t1.Url=Null then t1.MenuName+' (Master)' else t1.MenuName end  as MenuName,
        t1.ParentID as ParentID, 
        t2.Permission_ID,
        t2.RoleID,
        t2.B_Add,
        t2.B_Edit,
        t2.B_Delete,
        t2.B_View,
        t2.[B_Payment],
        t2.RoleName,
        (case when t1.ParentID=0 or t1.ParentID=Null then t1.ID else t1.ParentID end) sort_order,SL_NO
        from MENU_MASTER t1
        inner join
        (
          select TEMP_ID, RoleID,MenuID,B_Add, B_Edit, B_Delete, B_View, [B_Payment], RP.RoleName ,RP.Permission_ID  
          from @TABLE_TEMP RP
          group by MenuID,RoleID,MenuID,B_Add, B_Edit, B_Delete, B_View, [B_Payment], RP.RoleName ,TEMP_ID ,Permission_ID
        ) t2
        on t1.ID = t2.MenuID    order by sort_order,SL_NO  Asc

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