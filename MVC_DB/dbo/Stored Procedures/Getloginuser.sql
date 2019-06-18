-- [Getloginuser] 'projectmailtest19@gmail.com','4jW935EB' 
CREATE PROCEDURE [dbo].[Getloginuser] 
@Email nvarchar(max) = null,
@Password nvarchar(max) = null
AS
BEGIN
	
	SET NOCOUNT ON;

BEGIN try 
    BEGIN TRANSACTION 

    DECLARE @encryptPsswd NVARCHAR(max), 
            @User_type    NVARCHAR(max) 

    ---------------Encrypt password--------------------------------------- 
    SELECT @encryptPsswd = master.dbo.Fn_varbintohexstr( 
                           Hashbytes('MD5', @Password)) 

    ---------------End Encrypt password--------------------------------------- 
    IF NOT EXISTS (SELECT [email], 
                          [password] 
                   FROM   contact 
                   WHERE  [password] = @encryptPsswd 
                          AND [email] = @Email) 
      BEGIN 
          SELECT 'Please Enter valid Email ID and Password' AS CustomMessage, 
                 '2'                                        AS CustomErrorState 

          GOTO last_row; 
      END 

    SET @User_type = (SELECT r.NAME 
                      FROM   contact AS c 
                             INNER JOIN role AS r 
                                     ON r.id = c.roleid 
                      WHERE  [password] = @encryptPsswd 
                             AND [email] = @Email) 

    IF( @User_type = 'USER' 
         OR @User_type = 'AGENT' ) 
      BEGIN 
          SELECT 'User Logged In Successfully' AS CustomMessage, 
                 '0'                           AS CustomErrorState 

          SELECT cont.id          AS Contact_ID, 
                 bran.id          AS Branch_ID, 
                 Comp.id          AS Company_ID, 
                 bran.logopath    AS Branch_LogoPath, 
                 Comp.logopath    AS Company_LogoPath, 
                 cont.NAME        AS Contact_Name, 
                 bran.NAME        AS Branch_Name, 
                 Comp.companyname AS Company_Name, 
                 cont.roleid 
          FROM   contact AS cont 
                 INNER JOIN branch AS bran 
                         ON cont.branch_id = bran.id 
                 INNER JOIN company AS comp 
                         ON cont.company_id = comp.id 
          WHERE  cont.[password] = @encryptPsswd 
                 AND cont.[email] = @Email 
      END 

    IF( @User_type = 'BRANCH ADMIN' ) 
      BEGIN 
          SELECT 'Branch Admin Logged In Successfully' AS CustomMessage, 
                 '0'                                   AS CustomErrorState 

          SELECT cont.id          AS Contact_ID, 
                 bran.id          AS Branch_ID, 
                 Comp.id          AS Company_ID, 
                 bran.logopath    AS Branch_LogoPath, 
                 Comp.logopath    AS Company_LogoPath, 
                 cont.NAME        AS Contact_Name, 
                 bran.NAME        AS Branch_Name, 
                 Comp.companyname AS Company_Name, 
                 cont.roleid 
          FROM   contact AS cont 
                 INNER JOIN branch AS bran 
                         ON cont.branch_id = bran.id 
                 INNER JOIN company AS comp 
                         ON cont.company_id = comp.id 
          WHERE  cont.[password] = @encryptPsswd 
                 AND cont.[email] = @Email 
      END 

    IF( @User_type = 'COMPANY ADMIN' ) 
      BEGIN 
          SELECT 'Company Admin Logged In Successfully' AS CustomMessage, 
                 '0'                                    AS CustomErrorState 

          SELECT cont.id          AS Contact_ID, 
                 ''               AS Branch_ID, 
                 Comp.id          AS Company_ID, 
                 ''               AS Branch_LogoPath, 
                 Comp.logopath    AS Company_LogoPath, 
                 cont.NAME        AS Contact_Name, 
                 ''               AS Branch_Name, 
                 Comp.companyname AS Company_Name, 
                 cont.roleid 
          FROM   contact AS cont 
                 INNER JOIN company AS comp 
                         ON cont.company_id = comp.id 
          WHERE  cont.[password] = @encryptPsswd 
                 AND cont.[email] = @Email 
      END 

    IF( @User_type = 'SUPER ADMIN' ) 
      BEGIN 
          SELECT 'Super Admin Logged In Successfully' AS CustomMessage, 
                 '0'                                  AS CustomErrorState 

          SELECT cont.id   AS Contact_ID, 
                 ''        AS Branch_ID, 
                 ''        AS Company_ID, 
                 ''        AS Branch_LogoPath, 
                 ''        AS Company_LogoPath, 
                 cont.NAME AS Contact_Name, 
                 ''        AS Branch_Name, 
                 ''        AS Company_Name, 
                 cont.roleid 
          FROM   contact AS cont 
          WHERE  cont.[password] = @encryptPsswd 
                 AND cont.[email] = @Email 
      END 

    LAST_ROW: 

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