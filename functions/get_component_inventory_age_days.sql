/*
Get Component's Inventory Age in Days

**Description:** Calculates the number of days the oldest active batch of a component has been in the inventory (FIFO tracking). Only considers batches with positive stock.

## Parameters

- `@ComponentID`: ID of the component to check
## Usage

```sql
SELECT dbo.fn_GetComponentInventoryAgeDays(5) AS [DaysInStock];
```
*/

CREATE FUNCTION dbo.fn_GetComponentInventoryAgeDays (@ComponentID INT)
RETURNS INT
AS
BEGIN

    DECLARE @OldestStockDate DATETIME;

    SELECT @OldestStockDate = MIN(InventoryDate)
    FROM dbo.ComponentsInventory
    WHERE ComponentID = @ComponentID
      AND UnitsInStock > 0;

    IF @OldestStockDate IS NULL RETURN 0

    RETURN DATEDIFF(DAY, @OldestStockDate, GETDATE());

END;
GO

