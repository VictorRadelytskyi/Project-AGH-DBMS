/*
Valuate Stock Categories

**Description:** Summarizes inventory investment and manufacturing effort aggregated by category.

## Logic

1. Group products by their categories.
2. Left join `Warehouse` and `ProductRecipes` so items without stock or recipes still appear.
3. Use `ISNULL` to surface zero instead of `NULL` when stock is missing.
4. Multiply stock units by labor hours to derive total manufacturing effort held in inventory.

## Usage

```sql
SELECT * FROM vw_CategoryStockValuation;
```

## Business Value

- Highlights where capital is tied up in stock.
- Shows how much labor effort is currently sitting in the warehouse.
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
