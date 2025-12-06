-- Customers With Segments View

-- Prints a list of customers grouped by their demographic data including age, income, residency, children and other data.

CREATE VIEW vw_CustomersWithSegments
AS
SELECT 
	c.ID AS CustomerID,
	c.ContactName,
    c.ContactTitle,
    c.Address,
    c.City,
    c.Region,
    c.PostalCode,
    c.Country,
    c.PhoneNumber,
    c.Fax,
    cd.AgeGroup,
    CASE cd.AgeGroup 
    	WHEN 1 THEN '18-24'
         WHEN 2 THEN '25-34'
         WHEN 3 THEN '35-44'
         WHEN 4 THEN '45-54'
         WHEN 5 THEN '55-64'
         WHEN 6 THEN '65+'
         ELSE 'nieznana'
	END AS AgeGroupLabel,
	cd.IncomeGroup,
	CASE cd.IncomeGroup 
		WHEN 1 THEN 'niskie'
		WHEN 2 THEN 'średnie'
		WHEN 3 THEN 'wysokie'
		ELSE 'nieznane'
	END AS IncomeGroupLabel,
	cd.HasChildren,
	cd.IsCityResident
FROM Customers c
LEFT JOIN CustomerDemographics cd 
	ON c.CustomerDemographicsID = cd.ID;
GO
