/*
Production floor staff who actually manufacture the products.
*/
CREATE ROLE Role_Assembler;
GO

GRANT SELECT ON dbo.Orders TO Role_Assembler;
GRANT SELECT ON dbo.OrderDetails TO Role_Assembler;
GRANT SELECT ON dbo.Customers TO Role_Assembler;

GRANT EXECUTE ON dbo.StartOrderFulfillment TO Role_Assembler;
GRANT EXECUTE ON dbo.UpdateOrderItemProgress TO Role_Assembler;
GRANT EXECUTE ON dbo.CompleteOrderFulfillment TO Role_Assembler;
GRANT EXECUTE ON dbo.UpdateOrderItemProgress TO Role_Assembler;
GRANT EXECUTE ON dbo.IncrementOrderItemProgress TO Role_Assembler;

GRANT EXECUTE ON dbo.ConsumeComponentInventory TO Role_Assembler;

GRANT EXECUTE ON dbo.AddProductRecipe.sql TO Role_Assembler;
GRANT EXECUTE ON dbo.AddProductToWarehouse TO Role_Assembler;
GRANT EXECUTE ON dbo.AddRecipeIngredient TO Role_Assembler;
GRANT EXECUTE ON dbo.UpdateComponent TO Role_Assembler;
GRANT EXECUTE ON dbo.UpdateProductRecipe TO Role_Assembler;

GO
