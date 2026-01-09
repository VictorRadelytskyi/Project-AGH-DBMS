/*
ConsumeComponentStockFromInventory

Consumes a specified quantity of a component from the inventory
using FIFO (First-In, First-Out) logic based on InventoryDate.

It ensures data integrity during concurrent access using UPDLOCK.

It calculates the weighted average unit price of the consumed items.
If the inventory stock is insufficient to meet the requirement,
the remaining quantity is assumed to be purchased at the current 
catalog price from the Components table.

Parameters:

@ComponentID      - ID of the component to consume
@QuantityRequired - Total quantity needed to be consumed
@AverageUnitPrice - OUTPUT. The calculated weighted average cost per unit

Usage:

DECLARE @AvgCost DECIMAL(10,2);

EXEC ConsumeComponentStockFromInventory 
@ComponentID = 10, 
@QuantityRequired = 50,
@AverageUnitPrice = @AvgCost OUTPUT;

SELECT @AvgCost AS [ActualCostPerUnit];

*/

CREATE PROCEDURE dbo.ConsumeComponentStockFromInventory (
    @ComponentID INT,
    @QuantityRequired INT,
    @AverageUnitPrice DECIMAL(10, 2) OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @QuantityLeft INT = @QuantityRequired
    DECLARE @TotalPrice DECIMAL(10,2) = 0.00

    DECLARE @InventoryID INT
    DECLARE @BatchQuantity INT
    DECLARE @BatchPrice DECIMAL(10,2)
    DECLARE @BatchConsumedQuantity INT

    BEGIN TRY
        BEGIN TRANSACTION;

        WHILE @QuantityLeft > 0
        BEGIN
            SET @InventoryID = NULL

            SELECT TOP (1)
                @InventoryID = ID,
                @BatchQuantity = UnitsInStock,
                @BatchPrice = UnitPrice
            FROM ComponentsInventory WITH (UPDLOCK, ROWLOCK)
            WHERE ComponentID = @ComponentID
              AND UnitsInStock > 0
            ORDER BY InventoryDate ASC;

            IF @InventoryID IS NULL BREAK;

            SET @BatchConsumedQuantity = IIF(@BatchQuantity > @QuantityLeft, @QuantityLeft, @BatchQuantity)

            EXEC ConsumeComponentInventory
            @inventoryID = @InventoryID,
            @quantityToConsume = @BatchConsumedQuantity;

            SET @TotalPrice = @TotalPrice + (@BatchConsumedQuantity * @BatchPrice)
            SET @QuantityLeft = @QuantityLeft - @BatchConsumedQuantity
        END

        IF @QuantityLeft > 0
        BEGIN
            DECLARE @CatalogPrice DECIMAL(10, 2)

            SELECT @CatalogPrice = UnitPrice
            FROM Components
            WHERE ID = @ComponentID

            IF @CatalogPrice IS NULL THROW 51000, 'Komponent o podanym ID nie istnieje', 1;

            SET @TotalPrice = @TotalPrice + (@QuantityLeft * @CatalogPrice)
        END

        IF @QuantityRequired > 0
            SET @AverageUnitPrice = @TotalPrice / @QuantityRequired
        ELSE
            SET @AverageUnitPrice = 0

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        DECLARE @errorMsg NVARCHAR(2048) = 'Błąd podczas pobierania komponentu:' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
        THROW 52000, @errorMsg, 1;
    END CATCH
END;
GO
