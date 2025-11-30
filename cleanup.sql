/*
BEWARE!! THIS CODE REMOVES ALL TABLES
*/
DECLARE @sql NVARCHAR(MAX) = N'';

-- Generate the ALTER TABLE...DROP CONSTRAINT statements
SELECT @sql += N'ALTER TABLE ' 
            + QUOTENAME(s.name) + N'.' + QUOTENAME(t.name) 
            + N' DROP CONSTRAINT ' 
            + QUOTENAME(fk.name) + N';' + CHAR(13)
FROM sys.foreign_keys fk
INNER JOIN sys.tables t ON fk.parent_object_id = t.object_id
INNER JOIN sys.schemas s ON t.schema_id = s.schema_id;

-- Execute the generated statements
EXEC sp_executesql @sql;
GO

DECLARE @sql NVARCHAR(MAX) = N'';

-- Generate DROP TABLE statements for all user tables
SELECT @sql += N'DROP TABLE ' + QUOTENAME(s.name) + '.' + QUOTENAME(t.name) + N';'
FROM sys.tables t
INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE t.is_ms_shipped = 0 -- Exclude system tables
      AND t.name != 'sysdiagrams' -- Exclude the diagrams table (optional, but good practice)
      AND t.name != 'TableNameYouWantToKeep' -- Add more exclusions if needed
ORDER BY t.name;

-- Execute the generated statements
EXEC sp_executesql @sql;