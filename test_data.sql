PRINT '>>> RETRIEVING ALL DATA...';

-- 1. Independent Tables
SELECT * FROM [CustomerDemographics];
SELECT * FROM [Categories];
SELECT * FROM [Suppliers];
SELECT * FROM [EmployeePositions];
SELECT * FROM [ProductRecipes];

-- 2. First Level Dependencies
SELECT * FROM [Customers];
SELECT * FROM [Employees];
SELECT * FROM [Components];

-- 3. Second Level Dependencies
SELECT * FROM [Products];
SELECT * FROM [Orders];

-- 4. Third Level Dependencies
SELECT * FROM [Warehouse];
SELECT * FROM [OrderDetails];

PRINT '>>> DATA RETRIEVAL COMPLETE.';
PRINT '';
PRINT '>>> VERIFYING ROW COUNTS:';

-- Summary of Row Counts
SELECT 
    t.NAME AS TableName,
    p.rows AS RowCount_
FROM 
    sys.tables t
INNER JOIN      
    sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN 
    sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
WHERE 
    t.is_ms_shipped = 0
    AND i.OBJECT_ID > 255 
    AND i.index_id IN (0, 1) -- Heap or Clustered Index
ORDER BY 
    t.Name;
GO