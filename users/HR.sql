-- user role for Human Resources department

CREATE ROLE Role_HR;
GO

-- grant access to employees' data
GRANT SELECT ON dbo.Employees TO Role_HR;
GRANT SELECT ON dbo.EmployeePositions TO Role_HR;

-- allow employees data manipulation
GRANT EXECUTE ON dbo.AddEmployee TO Role_HR;
GRANT EXECUTE ON dbo.AddEmployeePosition TO Role_HR;
GRANT EXECUTE ON dbo.UpdateEmployee TO Role_HR;
GRANT EXECUTE ON dbo.UpdateEmployeePosition TO Role_HR;

-- allow quick access functions
GRANT EXECUTE ON dbo.fn_GetEmployeeFullName TO Role_HR;
GRANT EXECUTE ON dbo.fn_GetEmployeeProductivity TO Role_HR;
GRANT EXECUTE ON dbo.fn_GetManagerName TO Role_HR;
GO