/*
Inventory value (components) by Supplier

**Description:** Shows the total value of component inventory per supplier, limited to suppliers with positive stock value.
*/

CREATE VIEW dbo.vw_ComponentsInventoryValueBySupplier AS
WITH ValueData AS (
    SELECT
        ID,
        CompanyName,
        ContactName,
        Country,
        dbo.fn_CalculateSupplierTotalStockValue(ID) AS TotalStockValue
    FROM Suppliers
)
SELECT
    ID AS SupplierID,
    CompanyName,
    ContactName,
    Country,
    TotalStockValue
FROM ValueData
WHERE TotalStockValue > 0;
GO
