/*
UpdateCustomerDemographics

**Description:** Upserts (update if exists, insert if doesn't exist) demographic information for a specific customer.

## Parameters

- `@CustomerID`: ID of the customer to update (must be an existing customer)
- `@AgeGroup`: Optional. 1=18–24, 2=25–34, 3=35-44, 4=45-54, 5=55+.
- `@HasChildren`: Optional. 1 (True) or 0 (False).
- `@IncomeGroup`: Optional. 1=Low, 2=Medium, 3=High.
- `@IsCityResident`: Optional. 1 (True) or 0 (False).
## Usage

```sql
EXEC UpdateCustomerDemographics
@CustomerID = 10,
@AgeGroup = 2,
@HasChildren = 1,
@IncomeGroup = 3,
@IsCityResident = 1;
```
*/

CREATE OR ALTER PROCEDURE dbo.UpdateCustomerDemographics
    @CustomerID     INT,
    @AgeGroup       TINYINT = NULL,
    @HasChildren    BIT = NULL,
    @IncomeGroup    TINYINT = NULL,
    @IsCityResident BIT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CurrentDemoID INT;

    BEGIN TRY
        -- Check if Customer exists and get their current DemographicsID
        SELECT @CurrentDemoID = CustomerDemographicsID
        FROM dbo.Customers
        WHERE ID = @CustomerID;

        -- If @CurrentDemoID is NULL (or customer doesn't exist), we might need to handle validation.
        -- Assuming CustomerID is valid for this operation:

        IF @CurrentDemoID IS NOT NULL
        BEGIN
            -- Scenario 1: Update existing demographics record
            UPDATE dbo.CustomerDemographics
            SET
                AgeGroup = ISNULL(@AgeGroup, AgeGroup),
                HasChildren = ISNULL(@HasChildren, HasChildren),
                IncomeGroup = ISNULL(@IncomeGroup, IncomeGroup),
                IsCityResident = ISNULL(@IsCityResident, IsCityResident)
            WHERE ID = @CurrentDemoID;
        END
        ELSE
        BEGIN
            -- Scenario 2: Create new record and link it
            INSERT INTO dbo.CustomerDemographics (
                AgeGroup,
                HasChildren,
                IncomeGroup,
                IsCityResident
            )
            VALUES (
                @AgeGroup,
                @HasChildren,
                @IncomeGroup,
                @IsCityResident
            );

            DECLARE @NewDemoID INT = SCOPE_IDENTITY();

            UPDATE dbo.Customers
            SET CustomerDemographicsID = @NewDemoID
            WHERE ID = @CustomerID;
        END
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO
