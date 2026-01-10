/*
ComponentsInventoryLowStockWarning

Checks if component levels fall below a safety threshold (e.g., 10 units)
and alerts the system.
*/

CREATE TRIGGER ComponentsInventoryLowStockWarning 
ON ComponentsInventory
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM inserted WHERE UnitsInStock < 10)
    BEGIN 
        PRINT 'Warning: One or more components has reached low stock levels';
    END
END;
GO
