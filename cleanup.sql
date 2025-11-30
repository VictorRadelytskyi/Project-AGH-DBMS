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