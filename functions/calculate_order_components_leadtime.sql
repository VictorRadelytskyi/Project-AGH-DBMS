/*
WIP version

fn_CalculateOrderComponentsLeadtime

Calculates how many working days are required
till all the components are available for specified
ProductRecipeID and OrderQuantity

Logic:

1. Get ComponentID of those with not enough TOTAL units in stock
2. Get MAX of the LeadTimes of all Components from point 1

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
    WHERE ri.ProductRecipeID = @ProductRecipeID
    AND (ri.QuantityRequired * @OrderQuantity) > c.UnitsInStock -- tutaj do przegadania logika dostępności komponentów

    RETURN ISNULL(@MaxLeadTime, 0)

END