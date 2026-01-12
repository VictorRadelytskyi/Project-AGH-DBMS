/*
AddComponent

**Description:** Adds a new component definition to the catalog (Components table).

## Parameters

- `@supplierID`: ID of the supplier providing this component
- `@componentName`: Name of the component (e.g., 'Wooden Plank')
- `@componentType`: Category of the component (e.g., 'Wood', 'Metal')
- `@unitPrice`: Current catalog price per unit
- `@ID`: OUTPUT. Returns the generated ID of the new component
## Usage

```sql
DECLARE @NewComponentID INT;

EXEC AddComponent
@supplierID = 1,
@componentName = 'Oak Wood Sheet',
@componentType = 'Wood',
@unitPrice = 45.50,
@ID = @NewComponentID OUTPUT;

SELECT @NewComponentID AS [CreatedComponentID];
```
*/

CREATE PROCEDURE AddComponent @supplierID INT,
@componentName varchar(255),
@componentType varchar(255),
@unitPrice decimal(10,2),
@ID INT OUTPUT
AS 
BEGIN
SET NOCOUNT ON;

BEGIN TRY
    BEGIN TRAN AddComponent
        INSERT INTO
            Components (
                SupplierID,
                ComponentName,
                ComponentType,
                UnitPrice
            )
            VALUES (
                @supplierID,
                @componentName,
                @componentType,
                @unitPrice
            )

        SET @ID = CAST(SCOPE_IDENTITY() AS INT);

    COMMIT TRAN AddComponent 
END TRY 
BEGIN CATCH 
    IF @@TRANCOUNT > 0
        ROLLBACK TRAN AddComponent 
    DECLARE @msg NVARCHAR(2048) = 'Nie udało się dodać nowego komponentu:' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
    THROW 52000, @msg, 1;

END CATCH
END;
GO

