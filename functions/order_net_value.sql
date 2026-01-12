/*
Order Net Value

**Description:** Scalar function returning the net value of a given order Uses Products.VATMultipler and net UnitPrice from OrderDetails

## Usage

```sql
SELECT dbo.fn_OrderNetValue(1) AS OrderNetValue;
(using `dbo.` to make sure you're executing the function in the correct DB)
```
*/

CREATE FUNCTION dbo.fn_OrderNetValue (@OrderID INT)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @NetValue DECIMAL(18,2);

    SELECT
        @NetValue = SUM(
              od.UnitPrice          -- net unit price
            * od.Quantity
            * (1 - od.Discount)
            * p.VATMultipler        -- apply VAT for each product
        )
    FROM OrderDetails od
    JOIN Products     p ON p.ID = od.ProductID
    WHERE od.OrderID = @OrderID;

    RETURN ISNULL(@NetValue, 0);
END;
GO
