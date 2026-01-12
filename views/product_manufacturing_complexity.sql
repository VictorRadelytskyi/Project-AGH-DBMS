/*
Manufacturing Complexity by Product

**Description:** Ranks products by manufacturing difficulty based on required labor time and the variety of parts.

## Logic

1. Join `Products` to `ProductRecipes` and `RecipeIngredients`.
2. Count distinct components required per product.
3. Compute `ComplexityIndex = LabourHours * component count`; higher values indicate more complex items.

## Usage

```sql
SELECT * FROM vw_ProductManufacturingComplexity ORDER BY ComplexityIndex DESC;
```
*/

CREATE VIEW vw_ProductManufacturingComplexity
AS 
SELECT 
    p.ProductName,
    pr.LabourHours,
    COUNT(ri.ComponentID) AS DifferentComponentsRequired,
    (pr.LabourHours * COUNT(ri.ComponentID)) AS ComplexityIndex
    FROM
    Products p
    JOIN ProductRecipes pr
    ON p.ProductRecipesID = pr.ID
    JOIN RecipeIngredients ri
    ON pr.ID = ri.ProductRecipeID
    GROUP BY p.ProductName, pr.LabourHours;
GO
