/*
fn_CalculateOrderComponentsLeadtime

Calculates how many working days are required
till all the components are available for specified
ProductRecipeID and OrderQuantity

Logic:

1. Get ComponentID of those in the RecipeID
2. For each Component check LeadTime
3. Get sum of all stocks of the ComponentID in ComponentsInventory
4. If total stock of the component < RequiredQuantity then include its LeadTime in calculation
5. Return MAX of all included LeadTimes

Usage:
SELECT dbo.fn_CalculateOrderComponentsLeadtime(1, 50) AS [Czas Oczekiwania na Komponenty (Dni)]
*/

CREATE FUNCTION dbo.fn_CalculateOrderComponentsLeadtime (
    @ProductRecipeID INT,
    @OrderQuantity INT
)
RETURNS SMALLINT
AS
BEGIN

    DECLARE @MaxLeadTime SMALLINT;

    SELECT @MaxLeadTime = MAX(c.LeadTime)
    FROM RecipeIngredients ri
    JOIN Components c on c.ID = ri.ComponentID
    CROSS APPLY dbo.fn_CalculateComponentStock(c.ID) AS StockData
    WHERE ri.ProductRecipeID = @ProductRecipeID
        -- check components availability in stock
        AND (ri.QuantityRequired * @OrderQuantity) > StockData.TotalStock

    RETURN ISNULL(@MaxLeadTime, 0)

END