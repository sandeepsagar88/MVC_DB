-- [CHANGE_RESET_PASSWORD] '4' ,'2', '6', '6', '7nYF6F9A', '123',  '' ,'CHANGE'
CREATE PROCEDURE [dbo].[CHANGE_RESET_PASSWORD]
@Company_ID	    bigint=null,
@Branch_ID	    bigint=null, 
@Contact_ID		bigint=null, 
@Login_user_ID  bigint=null,
@Old_Password   nvarchar(max)=null,
@New_password   nvarchar(max)=null,
@EMAIL          nvarchar(max)=null,
@MODE           nvarchar(max)=null

AS
BEGIN
	


	SET NOCOUNT ON; 

BEGIN try 
    BEGIN TRANSACTION 

    DECLARE @encryptOLDPsswd NVARCHAR(max), 
            @encrypNEWPsswd  NVARCHAR(max), 
            @Email_ID        NVARCHAR(max), 
            @NEW_AUTOPSSWD   NVARCHAR(max) 

    ---------------Encrypt password--------------------------------------- 
    SELECT @encryptOLDPsswd = master.dbo.Fn_varbintohexstr( 
                              Hashbytes('MD5', @Old_Password)) 

    SELECT @encrypNEWPsswd = master.dbo.Fn_varbintohexstr( 
                             Hashbytes('MD5', @New_password)) 

    ---------------End Encrypt password--------------------------------------- 
    IF( @MODE = 'CHANGE' ) 
      BEGIN 
          IF NOT EXISTS (SELECT * 
                         FROM   contact 
                         WHERE  id = @Contact_ID 
                                AND branch_id = @Branch_ID 
                                AND company_id = @Company_ID 
                                AND password = @encryptOLDPsswd 
                                AND isactive = 1) 
            BEGIN 
                SELECT 'Please Enter Current Password Correctly' AS 
                       CustomMessage, 
                       '2'                                       AS 
                       CustomErrorState 

                GOTO last_row; 
            END 

          UPDATE contact 
          SET    password = @encrypNEWPsswd, 
                 updateddate = Getdate(), 
                 updatedby = @Login_user_ID 
          WHERE  id = @Contact_ID 
                 AND branch_id = @Branch_ID 
                 AND company_id = @Company_ID 
                 AND password = @encryptOLDPsswd 
                 AND isactive = 1 

          SELECT 'Password Successfully Changed' AS CustomMessage, 
                 '0'                             AS CustomErrorState 
      END 

    IF( @MODE = 'RESET' ) 
      BEGIN 
          SET @Email_ID=(SELECT email 
                         FROM   contact 
                         WHERE  id = @Contact_ID 
                                AND branch_id = @Branch_ID 
                                AND company_id = @Company_ID 
                                AND isactive = 1) 
          SET @NEW_AUTOPSSWD=(SELECT Cast((Abs(Checksum(Newid()))%10) AS VARCHAR 
                                     (1)) 
                                     + Char(Ascii('a')+(Abs(Checksum(Newid()))% 
                                     25)) 
                                     + Char(Ascii('A')+(Abs(Checksum(Newid()))% 
                                     25)) 
                                     + LEFT(Newid(), 5)) 

          UPDATE contact 
          SET    password = master.dbo.Fn_varbintohexstr( 
                            Hashbytes('MD5', @NEW_AUTOPSSWD)), 
                 updateddate = Getdate(), 
                 updatedby = @Login_user_ID 
          WHERE  id = @Contact_ID 
                 AND branch_id = @Branch_ID 
                 AND company_id = @Company_ID 
                 AND isactive = 1 

          --sp_CONFIGURE 'show advanced', 1 
          --GO 
          --RECONFIGURE 
          --GO 
          --sp_CONFIGURE 'Database Mail XPs', 1 
          --GO 
          --RECONFIGURE 
          --GO 
          --   USE msdb 
          --GO 
          --declare @profile_name nvarchar(Max), @recipients nvarchar(Max),@subject nvarchar(Max), @body nvarchar(Max)
          --EXEC sp_send_dbmail @profile_name='My TestMail', 
          --@recipients=@Email_ID, 
          --@subject='Reset password from Smartest Trucking', 
          --@body='Your New Password is' + @NEW_AUTOPSSWD  

          SELECT 
      'Password Reset Successful.. Please Check Email For New Password' 
      AS 
      CustomMessage, 
      '0' 
      AS 
      CustomErrorState 
      END 

    IF( @MODE = 'FORGET' ) 
      BEGIN 
          IF NOT EXISTS (SELECT * 
                         FROM   contact 
                         WHERE  email = @EMAIL 
                                AND isactive = 1) 
            BEGIN 
                SELECT 'EMAIL ID is not registered' AS CustomMessage, 
                       '2'                          AS CustomErrorState 

                GOTO last_row; 
            END 

          DECLARE @Login_user_ID_1 BIGINT=NULL 

          SET @NEW_AUTOPSSWD=(SELECT Cast((Abs(Checksum(Newid()))%10) AS VARCHAR 
                                     (1)) 
                                     + Char(Ascii('a')+(Abs(Checksum(Newid()))% 
                                     25)) 
                                     + Char(Ascii('A')+(Abs(Checksum(Newid()))% 
                                     25)) 
                                     + LEFT(Newid(), 5)) 
          SET @Login_user_ID_1=(SELECT id 
                                FROM   contact 
                                WHERE  email = @EMAIL 
                                       AND isactive = 1) 

          UPDATE contact 
          SET    password = master.dbo.Fn_varbintohexstr( 
                            Hashbytes('MD5', @NEW_AUTOPSSWD)), 
                 updateddate = Getdate(), 
                 updatedby = @Login_user_ID_1 
          WHERE  email = @EMAIL 
                 AND isactive = 1 

          SELECT 
      'Password Reset Successful.. Please Check Email For New Password' 
      AS 
      CustomMessage, 
      '0' 
      AS 
      CustomErrorState 

          SELECT email, 
                 @NEW_AUTOPSSWD AS newpasswd, 
                 NAME 
          FROM   contact 
          WHERE  email = @EMAIL 
                 AND isactive = 1 
      END 

    LAST_ROW: 

    COMMIT 
END try 

BEGIN catch 
    IF @@TRANCOUNT > 0 
      DECLARE @sql NVARCHAR(max) 

    ---------------------------------Error Message-------------------------------------------------- 
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

    ---------------------------------End error message-------------------------------------------------- 
    ROLLBACK 
END catch 
  END