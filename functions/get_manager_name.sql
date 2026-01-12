/*
Get Someone's Manager's Name

**Description:** Retrieves the full name of the direct supervisor (Manager) for a given employee.

## Parameters

- `@EmployeeID`: ID of the employee whose manager is being looked up
## Usage

```sql
SELECT dbo.fn_GetManagerName(15) AS [ManagerName];
```
*/

CREATE FUNCTION dbo.fn_GetManagerName (@EmployeeID INT)
RETURNS VARCHAR(512)
AS
BEGIN

    DECLARE @ManagerName VARCHAR(512);
    DECLARE @ManagerID INT;

    SELECT @ManagerID = ReportsTo
    FROM dbo.Employees
    WHERE ID = @EmployeeID;

    IF @ManagerID IS NOT NULL
        SET @ManagerName = dbo.fn_GetEmployeeFullName(@ManagerID);

    RETURN ISNULL(@ManagerName, 'Brak przełożonego');

END;
GO

