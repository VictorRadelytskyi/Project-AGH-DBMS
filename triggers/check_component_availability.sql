-- Cannot accept an order if the necessary components are out of stock AND permanently unavailable (LeadTime = -1).

CREATE OR ALTER TRIGGER dbo.trg_OrderDetails_CheckComponentAvailability
ON OrderDetails
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if any ordered product relies on a component that is:
    -- 1. Out of stock (UnitsInStock is not enough)
    -- 2. AND Discontinued (LeadTime = -1)
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN Products p ON i.ProductID = p.ID
        INNER JOIN ProductRecipes r ON p.ProductRecipesID = r.ID
        INNER JOIN RecipeIngredients ri ON r.ID = ri.ProductRecipeID
        INNER JOIN Components c ON ri.ComponentID = c.ID
        WHERE c.LeadTime = -1 
          AND c.UnitsInStock < (ri.QuantityRequired * i.Quantity)
    )
    BEGIN
        RAISERROR('Cannot place order: Product requires components that are out of stock and discontinued (LeadTime = -1).', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO
