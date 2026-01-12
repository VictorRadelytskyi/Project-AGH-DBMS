-- Working Database Cleanup Script
USE dev;
GO

PRINT 'Starting database cleanup...';

-- Step 1: Drop all views first (they may depend on functions)
DECLARE @sql NVARCHAR(MAX) = '';
SELECT @sql = @sql + 'DROP VIEW IF EXISTS [' + SCHEMA_NAME(schema_id) + '].[' + name + ']; '
FROM sys.views 
WHERE schema_id = SCHEMA_ID('dbo');

IF LEN(@sql) > 0
BEGIN
    PRINT 'Dropping views...';
    PRINT @sql;
    EXEC sp_executesql @sql;
    PRINT 'Views dropped.';
END

-- Step 2: Drop all triggers
SET @sql = '';
SELECT @sql = @sql + 'DROP TRIGGER IF EXISTS [' + name + ']; '
FROM sys.triggers 
WHERE is_ms_shipped = 0;

IF LEN(@sql) > 0
BEGIN
    PRINT 'Dropping triggers...';
    PRINT @sql;
    EXEC sp_executesql @sql;
    PRINT 'Triggers dropped.';
END

-- Step 3: Drop all procedures
SET @sql = '';
SELECT @sql = @sql + 'DROP PROCEDURE IF EXISTS [' + SCHEMA_NAME(schema_id) + '].[' + name + ']; '
FROM sys.procedures 
WHERE schema_id = SCHEMA_ID('dbo');

IF LEN(@sql) > 0
BEGIN
    PRINT 'Dropping procedures...';
    PRINT @sql;
    EXEC sp_executesql @sql;
    PRINT 'Procedures dropped.';
END

-- Step 4: Drop all functions
SET @sql = '';
SELECT @sql = @sql + 'DROP FUNCTION IF EXISTS [' + SCHEMA_NAME(schema_id) + '].[' + name + ']; '
FROM sys.objects 
WHERE type IN ('FN', 'IF', 'TF') AND schema_id = SCHEMA_ID('dbo');

IF LEN(@sql) > 0
BEGIN
    PRINT 'Dropping functions...';
    PRINT @sql;
    EXEC sp_executesql @sql;
    PRINT 'Functions dropped.';
END

-- Step 5: Drop all foreign key constraints
SET @sql = '';
SELECT @sql = @sql + 'ALTER TABLE [' + SCHEMA_NAME(schema_id) + '].[' + OBJECT_NAME(parent_object_id) + '] DROP CONSTRAINT [' + name + ']; '
FROM sys.foreign_keys;

IF LEN(@sql) > 0
BEGIN
    PRINT 'Dropping foreign keys...';
    PRINT @sql;
    EXEC sp_executesql @sql;
    PRINT 'Foreign keys dropped.';
END

-- Step 6: Drop all tables
SET @sql = '';
SELECT @sql = @sql + 'DROP TABLE IF EXISTS [' + SCHEMA_NAME(schema_id) + '].[' + name + ']; '
FROM sys.tables 
WHERE schema_id = SCHEMA_ID('dbo');

IF LEN(@sql) > 0
BEGIN
    PRINT 'Dropping tables...';
    PRINT @sql;
    EXEC sp_executesql @sql;
    PRINT 'Tables dropped.';
END

-- Step 7: Drop all indexes (non-system ones)
SET @sql = '';
SELECT @sql = @sql + 'DROP INDEX IF EXISTS [' + i.name + '] ON [' + SCHEMA_NAME(t.schema_id) + '].[' + t.name + ']; '
FROM sys.indexes i
INNER JOIN sys.tables t ON i.object_id = t.object_id
WHERE i.is_primary_key = 0 
  AND i.is_unique_constraint = 0 
  AND i.type > 0 
  AND t.schema_id = SCHEMA_ID('dbo');

IF LEN(@sql) > 0
BEGIN
    PRINT 'Dropping indexes...';
    PRINT @sql;
    EXEC sp_executesql @sql;
    PRINT 'Indexes dropped.';
END

PRINT 'Database cleanup completed successfully!';
GO