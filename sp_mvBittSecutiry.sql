/******************************************
sp_mvBittSecutiry Marcus Vinícius Bittencourt

Description: Displays a view of security items to adjust in the environment

Output: The result contains data from the check validation and the way to solve the points that were checked.

The first and new versions will be available at http://isqlserver.wordpress.com
where you can download new versions for free, read posts and get more info on the findings. 
To contribute code and see your name in the change log, submit your improvements &
ideas to mailto:mvbitt@gmail.com

Versions:

v0.1: Creation

v0.2:

Execution Example:

EXECUTE sp_BlitzSecurity
GO
************************************************************************/

-- Drop stored procedure if it already exists
DROP PROCEDURE if exists sp_mvBittSecutiry
GO

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_NAME = 'sp_mvBittSecutiry'
   AND SPECIFIC_CATALOG = 'dbmanutencao'
)
   DROP PROCEDURE sp_mvBittSecutiry
GO

CREATE PROCEDURE sp_mvBittSecutiry
AS
   -- =============================================
   -- CHECK IF CHECK_POLICY IS OFF
   -- =============================================
    select 'CHECK POLICY if off for user ' + name as 'CHECK_POLICY_OFF'
    from sys.sql_logins 
    where is_policy_checked = 0 
    and is_disabled = 0
    and name <> 'sa'

    SELECT 'ALTER LOGIN ' + QuoteName(name) + ' WITH CHECK_POLICY = ON;' as 'ADJUST OF CHECK_POLICY'
    FROM sys.sql_logins
    WHERE is_policy_checked = 0 
    and is_disabled = 0
    and name <> 'sa'
	    
    -- =============================================
    -- CHECK SA ENABLED
    -- =============================================	
    select name + ' is enabled' as 'SA IS ENABLED'
    from sys.sql_logins where name = 'sa' and is_disabled = 0

    SELECT 'ALTER LOGIN ' + QuoteName(name) + ' DISABLE' as 'DISABLE OF SA'
    FROM sys.sql_logins
    WHERE name = 'sa' 
    and is_disabled = 0

    -- =============================================
    -- CHECK Database Mail XPS ENABLED
    -- =============================================	
    select NAME + ' is enabled' FROM sys.configurations where name = 'Database Mail XPs' and value = 1
    
    select  'EXEC sp_configure ''show advanced options'', 0;',
		  'RECONFIGURE',
		  'EXEC sp_configure ''Database Mail XPs'', 0;',
		  'RECONFIGURE'    
        
    -- =============================================
    -- REVOKE XP PROCEDURES FROM PUBLIC
    -- =============================================
    SELECT 'USE MASTER; REVOKE EXEC ON xp_fixeddrives TO public;' +
				   'REVOKE EXEC ON xp_regread TO public;' +
				   'REVOKE EXEC ON xp_dirtree TO public;' AS 'REVOKE XP PROCEDURES FROM PUBLIC'
   
GO