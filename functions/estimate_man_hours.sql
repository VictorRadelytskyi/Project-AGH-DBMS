/*

fn_EstimateManHours

Calculates total man-hours required based on the product recipe.
    
Usage:
-- How many man-hours to build 50 units of Product 1?
SELECT dbo.fn_EstimateManHours(1, 50) AS TotalManHours;
*/

CREATE [dbo].[fn_EstimateManHours]
(
    @ProductID INT,
    @Quantity INT
)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @TotalHours DECIMAL(10, 2);

    SELECT @TotalHours = (r.LabourHours * @Quantity)
    FROM Products p
    INNER JOIN ProductRecipes r ON p.ProductRecipesID = r.ID
    WHERE p.ID = @ProductID;

    -- Return 0 if product or recipe not found to prevent NULL errors
    RETURN ISNULL(@TotalHours, 0.00);
END;
GO

