/*
VIEW: vw_InventoryAndProductionPlanning

PURPOSE: 
Provides a real-time audit of physical stock availability against outstanding 
customer demand. This view helps the logistics and production teams identify 
stockouts and prioritize manufacturing tasks.

LOGIC:
1. Physical Stock: Sums all units currently sitting in the Warehouse for each product.
2. Active Demand: Uses a subquery on OrderDetails to aggregate quantities that 
   have been ordered but not yet fulfilled (Quantity - QuantityFulfilled).
3. Net Balance: Subtracts total demand from physical stock. A negative balance 
   indicates that current orders cannot be fulfilled with existing inventory.
4. Status Flag: Categorizes products into 'Required additional production' or 
   'Extra products available' for quick decision-making.

COLUMNS:
- ProductID / ProductName: Identifiers for the item.
- CurrentStock: Total units physically present in the warehouse.
- OrderedNotFulfilled: Total units promised to customers but not yet ready.
- NetInventoryBalance: The gap between stock and demand.
- ProductionStatus: Actionable status label based on the balance.

USAGE:
SELECT * FROM dbo.vw_InventoryAndProductionPlanning 
WHERE NetInventoryBalance < 0; -- List only items that need to be made
*/

CREATE VIEW vw_InventoryAndProductionPlanning
AS
SELECT 
    p.ID AS ProductID,
    p.ProductName,
    ISNULL(SUM(w.UnitsInStock), 0) AS CurrentStock,
    ISNULL(PendingOrders.TotalOrdered, 0) AS OrderedNotFulfilled,
    -- What should be served:
    ISNULL(SUM(w.UnitsInStock), 0) - ISNULL(PendingOrders.TotalOrdered, 0) AS NetInventoryBalance,
    CASE 
        WHEN ISNULL(SUM(w.UnitsInStock), 0) < ISNULL(PendingOrders.TotalOrdered, 0) 
        THEN 'Required additional production' 
        ELSE 'Extra products available' 
    END AS ProductionStatus
FROM Products p
LEFT JOIN Warehouse w ON p.ID = w.ProductID
LEFT JOIN (
    -- Subquery that sums unprocessed yet orders
    SELECT ProductID, SUM(Quantity - QuantityFulfilled) AS TotalOrdered
    FROM OrderDetails
    GROUP BY ProductID
) AS PendingOrders ON p.ID = PendingOrders.ProductID
GROUP BY p.ID, p.ProductName, PendingOrders.TotalOrdered;
GO