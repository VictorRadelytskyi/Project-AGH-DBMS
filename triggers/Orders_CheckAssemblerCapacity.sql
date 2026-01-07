/*
TR_Orders_CheckAssemblerCapacity

An employee shouldn't have more orders assigned to them than @MaxConcurrentOrders

When an AssemblerEmployeeID is assigned or changed, check how many 
active orders (Started but not Finished) that employee currently has.
If it exceeds a limit (e.g., 5), block the assignment.
*/

CREATE OR ALTER TRIGGER dbo.TR_Orders_CheckAssemblerCapacity
ON dbo.Orders
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @MaxConcurrentOrders INT = 5;

    IF UPDATE(AssemblerEmployeeID) OR UPDATE(FulfillmentStart)
    BEGIN
        IF EXISTS (
            SELECT i.AssemblerEmployeeID
            FROM inserted i
            WHERE i.AssemblerEmployeeID IS NOT NULL
              AND i.FulfillmentFinish IS NULL
            GROUP BY i.AssemblerEmployeeID
            HAVING (
                SELECT COUNT(*)
                FROM dbo.Orders o
                WHERE o.AssemblerEmployeeID = i.AssemblerEmployeeID
                  AND o.FulfillmentStart IS NOT NULL
                  AND o.FulfillmentFinish IS NULL
            ) > @MaxConcurrentOrders
        )
        BEGIN
            DECLARE @Msg VARCHAR(255) = 'Capacity Limit Reached: This employee has too many active orders.';
            RAISERROR (@Msg, 16, 1);
            ROLLBACK TRANSACTION;
        END
    END
END;
GO
