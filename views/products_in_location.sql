/*
Products In Location

**Description:** Summarizes how each warehouse stock location is utilized, showing both total volume and product variety.

## Logic

- Groups data by `StockLocation` from `Warehouse`.
- Sums `UnitsInStock` to show total quantity stored in that slot.
- Counts distinct `ProductID` values to show how many product types share the location.

## Usage

```sql
SELECT * FROM vw_ProductsInLocation;
```

## Business Value

- Space management: identify locations that are empty or overcrowded.
- Audit/Inventory: quickly see how many unique SKUs a picker should expect in a given location.
*/

CREATE VIEW vw_ProductsInLocation 
AS 
SELECT 
    w.StockLocation, 
    SUM(w.UnitsInStock) AS TotalItemsInLocation,
    COUNT (DISTINCT w.ProductID) AS UniqueProductTypes
FROM Warehouse w
GROUP BY w.StockLocation;
GO
