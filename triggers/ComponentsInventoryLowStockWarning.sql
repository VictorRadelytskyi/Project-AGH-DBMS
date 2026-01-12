/*
ComponentsInventoryLowStockWarning

Monitors component inventory levels and provides warnings when stock
falls below safety thresholds to prevent production delays.

Business Rules:
- Threshold: 10 units (configurable)
- Triggers on stock level updates (not inserts)
- Provides system notification via PRINT statement
- Non-blocking - allows the update to proceed

Trigger Type: AFTER UPDATE
Table: ComponentsInventory

Logic:
- Monitors UnitsInStock changes
- Checks if any component falls below 10 units
- Issues warning message to system log
- Does not prevent the operation (informational only)

Usage Scenarios:
- Automatic alerts during component consumption
- Early warning system for procurement team
- Helps prevent stockouts and production delays

Example Behavior:
- Stock drops from 15 to 8 units -> Warning displayed
- Stock drops from 12 to 10 units -> No warning (exactly at threshold)
- Stock increases from 5 to 15 units -> Warning still shows (other components may be low)

Note: This is an informational trigger that doesn't block operations.
Consider implementing automated purchase orders for critical components.
*/

CREATE TRIGGER ComponentsInventoryLowStockWarning 
ON ComponentsInventory
AFTER UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM ComponentsInventory WHERE UnitsInStock < 10)
    BEGIN 
        PRINT 'Warning: One or more components has reached low stock levels';
    END
END;
GO
