/* 00_db_check.sql
   Lists all objects in the db of the types:
   1. Tables
   2. Views
   3. Procedures
   4. Functions
   5. Triggers
*/

SELECT *
FROM sys.objects
-- WHERE type IN ('FN', 'IF', 'TF') AND is_ms_shipped = 0 --functions
-- WHERE type IN ('V') AND is_ms_shipped = 0 --views
-- WHERE type = 'P' AND is_ms_shipped = 0 --procedures
-- WHERE type = 'TR' AND is_ms_shipped = 0 --triggers
-- WHERE type = 'U' AND is_ms_shipped = 0 --tables
WHERE type IN ('FN', 'IF', 'TF', 'V', 'P', 'U', 'TR') AND is_ms_shipped = 0 --all
ORDER BY type, name; 

-- Defined Roles check
-- SELECT *
-- FROM sys.database_principals
-- WHERE type = 'R'
--   AND is_fixed_role = 0
--   AND name <> 'public'
-- ORDER BY name;