/*
Customers by Segment

**Description:** Returns a table of customers that fit given demographic criteria
*/

-- Usage:

-- clients who are high earners
-- SELECT * FROM dbo.fn_CustomersBySegment(NULL, 3, NULL, NULL);

-- clients with kids who live in a city
-- SELECT * FROM dbo.fn_CustomersBySegment(NULL, NULL, 1, 1);


CREATE FUNCTION dbo.fn_CustomersBySegment (
	@AgeGroup		INT		= NULL,
	@IncomeGroup	INT		= NULL,
	@HasChildren	BIT		= NULL,
	@IsCityResident	BIT		= NULL
)
RETURNS TABLE
AS
RETURN
(
	SELECT
		c.ID					AS CustomerID,
		c.ContactName,
		c.City,
		c.Country,
		cd.AgeGroup,
		cd.IncomeGroup,
		cd.HasChildren,
		cd.IsCityResident
	FROM Customers c
	JOIN CustomerDemographics cd
		ON c.CustomerDemographicsID = cd.ID
	WHERE (@AgeGroup		IS NULL OR cd.AgeGroup		= @AgeGroup)
		AND (@IncomeGroup	IS NULL OR cd.IncomeGroup	= @IncomeGroup)
		AND (@HasChildren	IS NULL OR cd.HasChildren	= @HasChildren)
		AND (@IsCityResident IS NULL OR cd.IsCityResident = @IsCityResident)
);
GO
