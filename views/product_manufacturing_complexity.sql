/*
vw_ProductManufacturingComplexity

Ranks products by their manufacturing difficulty based on labor time 
and the variety of parts required.
    
Logic:
1. Joins Products to Recipes and RecipeIngredients.
2. Calculates the variety of parts using COUNT(ri.ComponentID).
3. ComplexityIndex = (LabourHours * Number of Unique Components).
   Higher numbers indicate items that are more "difficult" or time-consuming to manage.

Usage:
SELECT * FROM vw_ProductManufacturingComplexity ORDER BY ComplexityIndex DESC;
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
