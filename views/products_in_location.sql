/*
vw_ProductsInLocation

Summarizes the utilization of each stock location within the warehouse. 
It provides both the total volume of items and the variety of products 
stored in specific areas.
    
Logic:
1. Groups data by StockLocation from the Warehouse table.
2. Sum(UnitsInStock): Calculates the total quantity of all physical items 
   in that specific aisle, shelf, or bin.
3. Count(DISTINCT ProductID): Identifies how many different types of 
   products are sharing that location.

Usage:
SELECT * FROM vw_ProductsInLocation;

Business Value:
- Space Management: Identify which locations are nearly empty or overcrowded.
- Audit/Inventory: Quickly see how many unique SKUs a picker should expect 
  to find at a specific location.
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
