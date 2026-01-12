/*
Active Employees List

**Description:** Lists employees with productivity greater than zero along with their productivity factor and manager name.
*/

CREATE VIEW dbo.vw_ActiveEmployeesList AS
SELECT
    e.ID AS EmployeeID,
    dbo.fn_GetEmployeeFullName(e.ID) AS EmployeeName,
    ep.ProductivityFactor AS EmployeeProductivity,
    dbo.fn_GetManagerName(e.ID) AS ManagerName
FROM Employees e
INNER JOIN EmployeePositions ep ON ep.ID = e.EmployeePositionID
-- Employees not currently working (laid off, sick leave, etc.) have positions with productivity = 0
WHERE ep.ProductivityFactor > 0;
GO
