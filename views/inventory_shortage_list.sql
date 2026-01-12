/* Inventory Shortage List

Provides a real-time list of all products that are currently 
out of stock across the entire warehouse system.
    
Logic:
1. Starts with the full Products catalog.
2. Uses a LEFT JOIN on the Warehouse table to ensure products with 
   zero recorded stock entries are not ignored.
3. Groups results by product and category.
4. Uses the HAVING clause to filter for products where the total 
   aggregated stock is exactly 0.

Usage:
SELECT * FROM vw_InventoryShortageList;

Business Value:
- Procurement: Acts as a "To-Order" or "To-Manufacture" list.
- Sales: Informs the sales team which items are currently 
  unavailable for immediate fulfillment.
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
