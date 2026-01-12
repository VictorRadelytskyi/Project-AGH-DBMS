/*
HR manager

**Description:** Administrative office staff responsible for managing employee records and positions.
*/

CREATE ROLE Role_HRManager;
GO

GRANT SELECT ON dbo.vw_ActiveEmployeesList TO Role_HRManager;
GRANT SELECT ON dbo.Employees TO Role_HRManager;
GRANT SELECT ON dbo.EmployeePositions TO Role_HRManager;

GRANT EXECUTE ON dbo.AddEmployee TO Role_HRManager;
GRANT EXECUTE ON dbo.UpdateEmployee TO Role_HRManager;
GRANT EXECUTE ON dbo.AddEmployeePosition TO Role_HRManager;
GRANT EXECUTE ON dbo.UpdateEmployeePosition TO Role_HRManager;
GRANT EXECUTE ON dbo.fn_GetEmployeeFullName TO Role_HRManager;
GRANT EXECUTE ON dbo.fn_GetManagerName TO Role_HRManager;
GRANT EXECUTE ON dbo.fn_GetEmployeeProductivity TO Role_HRManager;
GO
