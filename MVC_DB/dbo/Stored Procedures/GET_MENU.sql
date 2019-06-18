-- GET_MENU '1','1',1,1
 
CREATE PROCEDURE [dbo].[GET_MENU] 
(
@company_id bigint=null,
@User_ID bigint=null,
@Branch_Id bigint=null,
@Role_ID int=null
)
	
AS
BEGIN
SET NOCOUNT ON;	 

	 BEGIN try 
          BEGIN TRANSACTION 

Declare @Menu nvarchar(Max)=null
DECLARE @TEMP_MENU TABLE
(
ID int Identity(1,1),
SL_NO   NVARCHAR(256),
MENU NVARCHAR(max)
)

IF(@Role_ID=1)
BEGIN
INSERT INTO @TEMP_MENU
SELECT SL_NO,'<li class="treeview">'+ (ISNULL('<a href="'+ISNULL(URL,'#')+'"><i class="fa fa-files-o"></i><span>'+MenuName+'</span>  <span class="pull-right-container">
                                <i class="fa fa-angle-left pull-right"></i>
              </span></a>'+'<ul class="treeview-menu">'+

  REPLACE (REPLACE (CHILDS,'&lt;','<'),'&gt;','>') 
 
 +'</ul>','<a href="'+ISNULL(URL,'#')+'"><i class="fa fa-circle-o"></i><span>'+MenuName+'</span> </a>')) +'</li>' 
 
    FROM (  
SELECT s.ID , s.MenuName  ,s.ParentID, s.URL,s.ICON,s.Status ,s.SL_NO,
    CHILDS = '&'+ STUFF(
                 (SELECT '<li><a href="'+ISNULL(K.URL,'#')+'"><i class="fa fa-th"></i><span>'+ Convert(Nvarchar(56),k.MenuName) + '</span>  </a></li>'  FROM MENU_MASTER k  
                  where k.ParentID=s.id and k.Status=1  order by k.SL_NO asc
     FOR XML PATH ('')), 1, 1, ''
               )  
FROM MENU_MASTER s   Where S.ParentID is null or S.ParentID =0   
)T order by SL_NO asc

SELECT @Menu=COALESCE(@Menu,'','') + Menu FROM  @TEMP_MENU 
 

SELECT @Menu as Url_link 
END
ELSE
BEGIN
 INSERT INTO @TEMP_MENU
SELECT  SL_NO,'<li class="treeview">'+ (ISNULL('<a href="'+ISNULL(URL,'#')+'"><i class="fa fa-files-o"></i><span>'+MenuName+'</span><span class="pull-right-container">
                                <i class="fa fa-angle-left pull-right"></i>
                            </span></a>'+'<ul class="treeview-menu">'+

  REPLACE (REPLACE (CHILDS,'&lt;','<'),'&gt;','>') 
 
 +'</ul>','<a href="'+ISNULL(URL,'#')+'"><i class="fa fa-circle-o"></i><span>'+MenuName+'</span></a>')) +'</li>' 
 
    FROM (  
SELECT s.ID , s.MenuName  ,s.ParentID, s.URL,s.ICON,s.Status ,SL_NO,
    CHILDS = '&'+ STUFF(
                 (SELECT '<li><a href="'+ISNULL(URL,'#')+'"><i class="fa fa-th"></i><span>'+ Convert(Nvarchar(56),k.MenuName) + '</span></a></li>'  FROM MENU_MASTER k 
        INNER JOIN ROLE_PERMISSION MCP on MCP.MenuID=k.ID
        where k.ParentID=s.id and MCP.RoleID=@Role_ID and MCP.Company_Id=@company_id and MCP.Branch_Id=@Branch_Id 
		and MCP.B_View=1 and ( MCP.B_Add=1 or  MCP.B_Edit=1 or  MCP.B_Delete=1 ) 
		 order by k.SL_NO asc
     FOR XML PATH ('')), 1, 1, ''
               )  
FROM MENU_MASTER s  Where S.ParentID is null or S.ParentID =0
)T
 
inner join ROLE_PERMISSION P on P.MenuID=T.ID AND P.RoleID=@Role_ID and  P.Company_Id=@company_id and P.Branch_Id=@Branch_Id
Where     P.B_View=1 and ( P.B_Add=1 or  P.B_Edit=1 or  P.B_Delete=1 )
 order by T.SL_NO asc 

SELECT @Menu=COALESCE(@Menu,'','') + Menu FROM  @TEMP_MENU 
SELECT @Menu as Url_link 
END


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