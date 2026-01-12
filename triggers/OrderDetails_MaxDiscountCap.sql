/* Maximum Discount Check

- Standard discounts up to 20% (0.20) are ALLOWED.
- Full waivers (100% / 1.00) are ALLOWED (e.g., replacements/marketing).
- Any value in between (e.g., 50%) is BLOCKED.
*/

CREATE OR ALTER TRIGGER [dbo].[TR_OrderDetails_MaxDiscountCap]
ON [dbo].[OrderDetails]
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF UPDATE(Discount)
    BEGIN
        IF EXISTS (
            SELECT 1
            FROM inserted
            WHERE Discount > 0.20 
              AND Discount < 1.00
        )
        BEGIN
            RAISERROR ('Discount must be <= 20%% OR exactly 100%%.', 16, 1);
            ROLLBACK TRANSACTION;
        END
    END
END;
GO
