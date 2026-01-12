-- Sales Agent

-- Front-office staff who manage client relationships and place orders.

CREATE ROLE Role_SalesAgent;
GO

-- read customer data
GRANT SELECT ON dbo.Customers TO Role_SalesAgent;
GRANT SELECT ON dbo.CustomerDemographics TO Role_SalesAgent;

-- create orders (can't directly modify status like FulfillmentStart)
GRANT SELECT, INSERT ON dbo.Orders TO Role_SalesAgent;
GRANT SELECT, INSERT ON dbo.OrderDetails TO Role_SalesAgent;

-- job-related procedures
GRANT EXECUTE ON dbo.AddCustomer TO Role_SalesAgent;
GRANT EXECUTE ON dbo.UpdateCustomerDemographics TO Role_SalesAgent;
GRANT EXECUTE ON dbo.PlaceFullOrder TO Role_SalesAgent;
GRANT EXECUTE ON dbo.AddSupplier TO Role_SalesAgent;
GRANT EXECUTE ON dbo.UpdateSupplier TO Role_SalesAgent;
GO
