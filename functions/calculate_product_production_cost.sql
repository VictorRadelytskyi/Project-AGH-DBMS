/*
fn_CalculateProductionBacklogDays

Calculates how many working days are required to fulfill 
ALL currently listed orders, based on the total workforce 
capacity and a 7-hour working day. (8hr shift = 7hrs work + 1hr lunch, breaks etc.)
    
Logic:
1. Sum((od.Quantity - od.QuantityFulfilled) * pr.LabourHours) = Total Work Needed
2. Sum(ep.ProductivityFactor * 7 hours) = Total Daily Capacity
3. Work Needed / Daily Capacity = Days to Clear Backlog

Usage:
SELECT dbo.fn_CalculateProductionBacklogDays() AS ProductionDaysLeft;
*/

CREATE FUNCTION dbo.fn_GetProductProductionCost (
    @ProductID INT,
    @HourlyRate DECIMAL(10,2)
) RETURNS DECIMAL (10,2)
AS
BEGIN
    DECLARE @TOTALCOST DECIMAL(10,2);

    SELECT @TOTALCOST = (
        -- sum of component costs
        SELECT SUM(ri.QuantityRequired * c.UnitPrice)
        FROM Products p
        JOIN RecipeIngredients ri
        ON ri.ProductRecipesID = p.ProductRecipesID
        JOIN Components c
        ON ri.ComponentID = c.ID
        WHERE p.ID = @ProductID
    ) + (
        -- sum of labor hours cost
        SELECT pr.LabourHours * @HourlyRate
        FROM Products p
        JOIN ProductRecipes pr
        ON p.ProductRecipesID = pr.ID
        WHERE p.ID = @ProductID
    );

    RETURN ISNULL(@TOTALCOST, 0);
END;
GO