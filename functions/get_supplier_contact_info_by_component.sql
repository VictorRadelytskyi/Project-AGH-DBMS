/*
Get Supplier's Contact Info By Component

**Description:** Retrieves formatted contact details (Company Name, Contact Name, Phone) for the supplier responsible for a specific component.

## Parameters

- `@ComponenID`: ID of the component
## Usage

```sql
SELECT dbo.fn_GetSupplierContactInfoByComponent(10) AS [SupplierContact];
```
*/

CREATE FUNCTION dbo.fn_GetSupplierContactInfoByComponent (@ComponentID INT)
RETURNS VARCHAR(600)
AS
BEGIN

    DECLARE @ContactInfo VARCHAR(600);

    SELECT TOP (1) @ContactInfo = s.CompanyName + ' (' + s.ContactName + '): ' + s.PhoneNumber
    FROM dbo.Suppliers s
    INNER JOIN dbo.Components c ON c.SupplierID = s.ID
    WHERE c.ID = @ComponentID;

    RETURN ISNULL(@ContactInfo, 'Brak danych dostawcy');

END;
GO
