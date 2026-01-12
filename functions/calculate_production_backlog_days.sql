/*
Calculate Production Backlog Days

Calculates how many working days are required to fulfill 
ALL currently listed orders, based on the total workforce 
capacity and a 7-hour working day. (8hr shift = 7hrs work + 1hr lunch, breaks etc.)
    
Logic:

1. Sum(OrderQuantity * RecipeLabourHours) = Total Work Needed
2. Sum(EmployeeProductivity * 7 hours)    = Total Daily Capacity
3. Work Needed / Daily Capacity           = Days to Clear Backlog

Usage:
`SELECT fn_CalculateProductionBacklogDays() AS ProductionDaysLeft;`

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
