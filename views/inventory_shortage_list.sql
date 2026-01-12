/*
Inventory Shortage List

**Description:** Provides a real-time list of products that are currently out of stock across the warehouse system.

## Logic

1. Start with the full `Products` catalog.
2. Left join `Warehouse` to keep products with zero stock entries.
3. Group by product and category.
4. Filter to rows where total aggregated stock equals zero.

## Usage

```sql
SELECT * FROM vw_InventoryShortageList;
```

## Business Value

- Procurement: acts as a “to-order” or “to-manufacture” list.
- Sales: informs the team which items are unavailable for immediate fulfillment.
*/

CREATE VIEW vw_InventoryShortageList
AS
SELECT
    p.ID,
    p.ProductName,
    c.CategoryName,
    ISNULL(SUM(w.UnitsInStock), 0) AS Available
FROM 
Products p
JOIN Categories c
ON p.CategoryID = c.ID
LEFT JOIN Warehouse w
ON p.ID = w.ProductID
GROUP BY p.ID, p.ProductName, c.CategoryName
HAVING ISNULL(SUM(w.UnitsInStock), 0) = 0;
GO
