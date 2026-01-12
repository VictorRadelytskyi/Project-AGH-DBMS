/*
Get Product Production Cost

Calculates the total manufacturing cost of a product by simulating 
the FIFO (First-In, First-Out) consumption of components and adding 
labor costs.

Logic:
1. Labor Cost: Simple calculation (Product's LabourHours * Input @HourlyRate).
2. Component Cost (Simulated FIFO):
   - Uses a Window Function (SUM OVER) to create a running total of 
     available stock across batches, ordered by InventoryDate.
   - For each batch, it calculates the "overlap" between what is required 
     for the recipe and what is available in that specific batch.
   - If the total warehouse stock is less than the recipe requirement, 
     the remainder is priced using the 'Catalog Price' from the Components table.
3. Total: Sum of (Layered Warehouse Costs + Shortage Catalog Costs + Labor).

Usage:
-- Calculate cost for Product ID 5 at a labor rate of $25/hr
SELECT dbo.fn_GetProductProductionCost(5, 25.00) AS EstimatedUnitCost;

Business Value:
Allows the sales and finance teams to get a high-precision cost estimate 
based on actual historical purchase prices currently sitting in the 
warehouse, rather than just theoretical catalog prices.
*/

CREATE FUNCTION dbo.fn_GetProductProductionCost (
    @ProductID INT,
    @HourlyRate DECIMAL(10,2)
) RETURNS DECIMAL (10,2)
AS
BEGIN
    DECLARE @TotalComponentCost DECIMAL(10,2) = 0;
    DECLARE @LaborCost DECIMAL(10,2) = 0;

    -- Calculate Labor Cost first (simple)
    SELECT @LaborCost = pr.LabourHours * @HourlyRate
    FROM Products p
    JOIN ProductRecipes pr ON p.ProductRecipesID = pr.ID
    WHERE p.ID = @ProductID;

    -- Calculate Component Cost using a Simulated FIFO CTE
    ;WITH ComponentRequirements AS (
        -- What do we actually need?
        SELECT 
            ri.ComponentID, 
            ri.QuantityRequired,
            c.UnitPrice AS CatalogPrice
        FROM RecipeIngredients ri
        JOIN Products p ON p.ProductRecipesID = ri.ProductRecipeID
        JOIN Components c ON ri.ComponentID = c.ID
        WHERE p.ID = @ProductID
    ),
    InventoryDepth AS (
        -- Calculate Running Totals of stock
        SELECT 
            ci.ComponentID,
            ci.UnitPrice AS BatchPrice,
            ci.UnitsInStock,
            -- Sum of all stock in this batch and previous (older) batches
            SUM(ci.UnitsInStock) OVER (PARTITION BY ci.ComponentID ORDER BY ci.InventoryDate ASC, ci.ID ASC) 
                - ci.UnitsInStock AS StockBeforeThisBatch,
            SUM(ci.UnitsInStock) OVER (PARTITION BY ci.ComponentID ORDER BY ci.InventoryDate ASC, ci.ID ASC) 
                AS StockIncludingThisBatch
        FROM ComponentsInventory ci
        WHERE ci.UnitsInStock > 0
    ),
    CostPerComponent AS (
        SELECT 
            cr.ComponentID,
            -- Logic: Calculate how much of THIS specific batch we are using
            SUM(
                CASE 
                    -- Batch is entirely needed
                    WHEN inv.StockIncludingThisBatch <= cr.QuantityRequired 
                        THEN inv.UnitsInStock * inv.BatchPrice
                    -- Batch is partially needed to reach the total
                    WHEN inv.StockBeforeThisBatch < cr.QuantityRequired 
                        THEN (cr.QuantityRequired - inv.StockBeforeThisBatch) * inv.BatchPrice
                    ELSE 0 
                END
            ) AS WarehousePartCost,
            -- Logic: Calculate how much we still need to "buy" at catalog price
            MAX(
                CASE 
                    WHEN ISNULL(inv.MaxStock, 0) < cr.QuantityRequired 
                        THEN (cr.QuantityRequired - ISNULL(inv.MaxStock, 0)) * cr.CatalogPrice
                    ELSE 0 
                END
            ) AS CatalogPartCost
        FROM ComponentRequirements cr
        LEFT JOIN (
            -- Subquery to get max stock reached to find the "shortage"
            SELECT *, MAX(StockIncludingThisBatch) OVER (PARTITION BY ComponentID) as MaxStock
            FROM InventoryDepth
        ) inv ON cr.ComponentID = inv.ComponentID
        GROUP BY cr.ComponentID, cr.QuantityRequired, cr.CatalogPrice
    )
    SELECT @TotalComponentCost = SUM(WarehousePartCost + CatalogPartCost)
    FROM CostPerComponent;

    RETURN ISNULL(@TotalComponentCost + @LaborCost, 0);
END;
GO