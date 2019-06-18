-- [LOGIN_CHECK2] 'projectmailtest19@gmail.com','4jW935EB' 
CREATE PROCEDURE [dbo].[LOGIN_CHECK2] 
	@UID varchar(max),
	@PWD nvarchar(max)
AS
BEGIN
	 SET NOCOUNT ON;

	 BEGIN try 
    BEGIN TRANSACTION 

    DECLARE @encryptPsswd NVARCHAR(max) 

    SELECT @encryptPsswd = master.dbo.Fn_varbintohexstr(Hashbytes('MD5', @PWD)) 

    DECLARE @R_Count     INT=0, 
            @COUNT_EMAIL INT=0, 
            @COUNT_PASS  INT=0, 
            @COUNT_ISD   INT=0; 

    SELECT @R_Count = Count(*) 
    FROM   log_count 
    WHERE  [user_id] = @UID 
           AND CONVERT(NVARCHAR(10), [log_date], 103) = 
               CONVERT(NVARCHAR(10), Getdate(), 103) 

    IF( @R_Count >= 5 ) 
      BEGIN 
          SELECT 'Your account has been disabled temporarily !' AS MESSAGE, 
                 '1'                                            AS ERROR_ID 

          RETURN; 
      END 

    SELECT @COUNT_EMAIL = Count(*) 
    FROM   contact AS UM 
    WHERE  UM.email = @UID 

    IF( @COUNT_EMAIL = 0 ) 
      BEGIN 
          SELECT 'Invalide user id !' AS MESSAGE, 
                 '1'                  AS ERROR_ID 

          RETURN; 
      END 

    SELECT @COUNT_PASS = Count(*) 
    FROM   contact AS UM 
    WHERE  UM.email = @UID 
           AND UM.password = @encryptPsswd 

    IF( @COUNT_PASS = 0 ) 
      BEGIN 
          SELECT 'Invalide password !' AS MESSAGE, 
                 '1'                   AS ERROR_ID 

          -- For checking 5 time wronge password  
          INSERT INTO [dbo].[log_count] 
                      ([user_id], 
                       [log_date]) 
          VALUES     (@UID, 
                      Getdate()) 

          RETURN; 
      END 

    SELECT @COUNT_ISD = Count(*) 
    FROM   contact AS UM 
    WHERE  UM.email = @UID 
           AND UM.password = @encryptPsswd 
           AND UM.isactive = 1 

    IF( @COUNT_ISD = 0 ) 
      BEGIN 
          SELECT 'Your credential has been deactivated ! ' AS MESSAGE, 
                 '1'                                       AS ERROR_ID 

          RETURN; 
      END 

    DECLARE @TEMP TABLE 
      ( 
         id                INT IDENTITY(1, 1), 
         [user_id]         NVARCHAR(max) NULL, 
         role_id           NVARCHAR(max) NULL, 
         role_name         NVARCHAR(max) NULL, 
         logo              NVARCHAR(max) NULL, 
         company_name      NVARCHAR(max) NULL, 
         [user_name]       NVARCHAR(max) NULL, 
         company_id        NVARCHAR(max) NULL, 
         branch_id         NVARCHAR(max) NULL, 
         is_company_active NVARCHAR(max) NULL, 
         is_branch_active  NVARCHAR(max) NULL, 
         [message]         NVARCHAR(max) NULL, 
         error_id          NVARCHAR(max) NULL 
      ) 

    INSERT INTO @TEMP 
    SELECT UM.id, 
           UM.roleid, 
           RM.NAME, 
           C.logopath, 
           C.companyname, 
           Upper(UM.NAME)        AS NAME, 
           C.id                  AS CompanyID, 
           UM.branch_id, 
           Isnull(C.isactive, 1) AS IS_COMPANY_ACTIVE, 
           Isnull(B.isactive, 1) AS IS_BRANCH_ACTIVE, 
           'SUCESS'              AS MESSAGE, 
           '0'                   AS ERROR_ID 
    FROM   contact UM 
           LEFT JOIN company C 
                  ON UM.company_id = C.id 
           LEFT JOIN role RM 
                  ON UM.roleid = RM.id 
           LEFT JOIN branch B 
                  ON B.company_id = C.id 
    WHERE  UM.email = @UID 
           AND UM.password = @encryptPsswd 
           AND UM.isactive = 1 

    DELETE log_count 
    WHERE  [user_id] = @UID 

    DECLARE @TEMP_MENU TABLE 
      ( 
         id   INT IDENTITY(1, 1), 
         menu NVARCHAR(max) NULL 
      ) 
    DECLARE @COMPANY_ID NVARCHAR(max)=NULL, 
            @USER_ID    NVARCHAR(max)= NULL, 
            @BRANCH_ID  NVARCHAR(max) = NULL, 
            @ROLE_ID    NVARCHAR(max) = NULL 

    SELECT @COMPANY_ID = company_id, 
           @USER_ID = id, 
           @BRANCH_ID = branch_id, 
           @ROLE_ID = role_id 
    FROM   @TEMP 

    INSERT INTO @TEMP_MENU 
    EXEC Get_menu 
      @company_id =@COMPANY_ID, 
      @User_ID =@USER_ID, 
      @Branch_Id =@BRANCH_ID, 
      @Role_ID =@ROLE_ID 

    SELECT MU.*, 
           M.menu 
    FROM   @TEMP_MENU M, 
           @TEMP MU 
    WHERE  M.id = MU.id 

    SELECT M.id, 
           M.menuname, 
           NULLIF(M.url, '#') AS url, 
           roleid, 
           b_add, 
           b_edit, 
           b_delete, 
           b_view, 
           CASE 
             WHEN ( b_add = 1 
                     OR b_edit = 1 
                     OR b_delete = 1 
                     OR b_view = 1 ) THEN 1 
             ELSE 0 
           END                AS Status, 
           branch_id, 
           company_id 
    FROM   menu_master M 
           INNER JOIN role_permission P 
                   ON P.menuid = M.id 
    WHERE  roleid = @ROLE_ID 
           AND branch_id = Isnull(@BRANCH_ID, 1) 
           AND company_id = Isnull(@COMPANY_ID, 1) 

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