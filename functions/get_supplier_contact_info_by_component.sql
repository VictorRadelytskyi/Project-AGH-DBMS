CREATE FUNCTION dbo.fn_GetSupplierContactInfoByComponent (@ComponenID INT)
RETURNS VARCHAR(600)
AS
BEGIN

    DECLARE @ContactInfo VARCHAR(600);

    SELECT TOP (1) @ContactInfo = s.CompanyName + ' (' + s.ContactName + '): ' + s.PhoneNumber
    FROM dbo.Suppliers s
    INNER JOIN dbo.Components c ON c.SupplierID = s.ID
    WHERE c.ID = @ComponenID;

    RETURN ISNULL(@ContactInfo, 'Brak danych dostawcy');

END;
GO