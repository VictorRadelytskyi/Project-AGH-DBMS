/*
ApplyVolumeDiscount

Calculates the total value of an order and applies a percentage discount to all
items in that order based on defined volume thresholds. Updates the per-line
`Discount` so downstream calculations stay consistent.

**Volume tiers**
- If order total > **5,000.00**, apply **10% (0.10)**.
- If order total > **1,000.00**, apply **5% (0.05)**.
- Otherwise, apply **0% (0.00)**.

**Usage**
```sql
EXEC ApplyVolumeDiscount @OrderID = 123;
```
*/

CREATE OR ALTER PROCEDURE [dbo].[ApplyVolumeDiscount]
    @OrderID INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @OrderTotal DECIMAL(10,2);
    DECLARE @DiscountRate DECIMAL(5,4);

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Calculate the current total value of the order (before discount)
        -- We look at UnitPrice * Quantity for all lines in this order
        SELECT @OrderTotal = SUM(Quantity * UnitPrice)
        FROM [dbo].[OrderDetails]
        WHERE OrderID = @OrderID;

        -- Handle case where order is empty or NULL
        SET @OrderTotal = ISNULL(@OrderTotal, 0);

        -- 2. Determine Discount Rate based on Business Rules (Thresholds)
        -- These hardcoded values could arguably be moved to a configuration table in a larger system
        IF @OrderTotal >= 5000.00
            SET @DiscountRate = 0.10; -- 10%
        ELSE IF @OrderTotal >= 1000.00
            SET @DiscountRate = 0.05; -- 5%
        ELSE
            SET @DiscountRate = 0.00; -- 0%

        -- 3. Apply the discount to the lines
        -- Schema stores Discount per line, so I update all lines for this OrderID
        UPDATE [dbo].[OrderDetails]
        SET Discount = @DiscountRate
        WHERE OrderID = @OrderID;

        COMMIT TRANSACTION;
        
        -- Return the applied rate
        SELECT @OrderTotal AS [OriginalTotal], @DiscountRate AS [AppliedDiscount];

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        THROW;
    END CATCH
END;
GO
