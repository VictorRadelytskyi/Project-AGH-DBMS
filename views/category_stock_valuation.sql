/* Valuate Stock Categories 

Provides a strategic summary of inventory investment and manufacturing 
effort aggregated by category.
    
Logic:
1. Groups products into their respective categories.
2. Uses LEFT JOIN on Warehouse and ProductRecipes to ensure products 
   without stock or without defined recipes are still included in counts.
3. ISNULL(SUM(...)): Ensures that if a category has no items in the 
   warehouse, the report shows 0 instead of NULL.
4. TotalLabourHoursSpentManufacturing: Multiplies the stock of each 
   item by its required labor hours and sums them up.

Usage:
SELECT * FROM vw_CategoryStockValuation;

Business Value:
Allows management to see where capital is "frozen" in stock and how much 
human labor is currently sitting in the warehouse.
*/

CREATE VIEW vw_CategoryStockValuation
AS 
SELECT 
    c.CategoryName,
    COUNT (DISTINCT p.ID) AS ProductsAvailable,
    ISNULL(SUM(w.UnitsInStock), 0) AS TotalUnits,
    ISNULL(SUM(w.UnitsInStock * p.UnitPrice), 0) AS TotalCategoryPrice,
    ISNULL(SUM(pr.LabourHours * w.UnitsInStock), 0) AS TotalLabourHoursSpentManufacturing
    FROM 
    Products p
    JOIN Categories c
    ON p.CategoryID = c.ID
    LEFT JOIN ProductRecipes pr
    ON p.ProductRecipesID = pr.ID
    LEFT JOIN Warehouse w
    ON p.ID = w.ProductID
    GROUP BY c.CategoryName;
GO
