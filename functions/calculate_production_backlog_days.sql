/*
Calculate Production Backlog Days

**Description:** Estimates how many working days are required to fulfill all current orders given the workforce capacity and a 7‑hour working day (8‑hour shift with breaks).

## Logic

1. Calculate total work needed: `SUM(OrderQuantity * RecipeLabourHours)`.
2. Calculate total daily capacity: `SUM(EmployeeProductivity * 7 hours)`.
3. Divide work needed by daily capacity to get days required to clear the backlog.

## Usage

```sql
SELECT fn_CalculateProductionBacklogDays() AS ProductionDaysLeft;
```
*/

CREATE FUNCTION dbo.fn_CalculateProductionBacklogDays ()
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @TotalLabourHoursNeeded DECIMAL(10, 2);
    DECLARE @TotalDailyCapacity DECIMAL(10, 2);

    SELECT @TotalLabourHoursNeeded = SUM(dbo.fn_EstimateManHours(ProductID, Quantity))
    FROM [OrderDetails];

    SELECT @TotalDailyCapacity = SUM(ep.ProductivityFactor * 7.00)
    FROM [Employees] e
    INNER JOIN [EmployeePositions] ep ON e.EmployeePositionID = ep.ID
    WHERE ep.ProductivityFactor > 0;

    IF @TotalLabourHoursNeeded = 0 RETURN 0.00;
    IF @TotalDailyCapacity IS NULL OR @TotalDailyCapacity = 0 RETURN -1.00;

    RETURN @TotalLabourHoursNeeded / @TotalDailyCapacity;
END;
GO
