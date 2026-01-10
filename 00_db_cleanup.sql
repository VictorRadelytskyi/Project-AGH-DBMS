/* 00_cleanup.sql
   PERFORMS A FULL DATABASE RESET.
   1. Drops all Foreign Key Constraints (to unblock table deletion).
   2. Drops all Tables (deletes all DATA and Triggers).
   3. Drops all Procedures, Views, and Functions.
*/
DECLARE @sql NVARCHAR(MAX) = N'';

-- 1. Generate DROP statements for Foreign Keys
SELECT @sql += 'ALTER TABLE ' 
               + QUOTENAME(SCHEMA_NAME(schema_id)) + '.' + QUOTENAME(OBJECT_NAME(parent_object_id))
               + ' DROP CONSTRAINT ' + QUOTENAME(name) + ';' + CHAR(13)
FROM sys.foreign_keys;

-- 2. DROP Tables
SELECT @sql += 'DROP TABLE ' 
               + QUOTENAME(SCHEMA_NAME(schema_id)) + '.' + QUOTENAME(name) + ';' + CHAR(13)
FROM sys.tables;

-- 3. Generate DROP statements for Procedures
SELECT @sql += 'DROP PROCEDURE ' + QUOTENAME(SCHEMA_NAME(schema_id)) + '.' + QUOTENAME(name) + '; '
FROM sys.objects
WHERE type = 'P' AND is_ms_shipped = 0;

-- 4. Generate DROP statements for Views
SELECT @sql += 'DROP VIEW ' + QUOTENAME(SCHEMA_NAME(schema_id)) + '.' + QUOTENAME(name) + '; '
FROM sys.objects
WHERE type = 'V' AND is_ms_shipped = 0;

-- 5. Generate DROP statements for Functions (Scalar, Inline, Table-Valued)
SELECT @sql += 'DROP FUNCTION ' + QUOTENAME(SCHEMA_NAME(schema_id)) + '.' + QUOTENAME(name) + '; '
FROM sys.objects
WHERE type IN ('FN', 'IF', 'TF') AND is_ms_shipped = 0;

-- Execute SQL
-- PRINT @sql; -- Uncomment to debug
EXEC sp_executesql @sql;
PRINT 'Database wiped successfully. All Tables, Data, and Objects are gone.';
GO