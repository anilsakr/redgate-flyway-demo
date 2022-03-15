SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
PRINT N'Dropping constraints from [ref].[Barlines]'
GO
ALTER TABLE [ref].[Barlines] DROP CONSTRAINT [PK__Barlines__A04047B59155B95C]
GO
PRINT N'Dropping constraints from [ref].[BuildPlanJobs]'
GO
ALTER TABLE [ref].[BuildPlanJobs] DROP CONSTRAINT [PK__BuildPla__056690E27CF2D7E0_OLD]
GO
PRINT N'Dropping constraints from [ref].[Barlines]'
GO
ALTER TABLE [ref].[Barlines] DROP CONSTRAINT [DF__Barlines__descri__658C0CBD]
GO
PRINT N'Dropping constraints from [ref].[BuildPlanJobs]'
GO
ALTER TABLE [ref].[BuildPlanJobs] DROP CONSTRAINT [DF__BuildPlan__descr__668030F6]
GO
PRINT N'Dropping [ref].[BuildPlanJobs]'
GO
DROP TABLE [ref].[BuildPlanJobs]
GO
PRINT N'Dropping [ref].[Barlines]'
GO
DROP TABLE [ref].[Barlines]
GO
PRINT N'Altering [dbo].[uspGetBillOfMaterials]'
GO
ALTER PROCEDURE [dbo].[uspGetBillOfMaterials]
    @StartProductID [int],
    @CheckDate [datetime]
AS
BEGIN
    SET NOCOUNT ON;

    -- Use recursive query to generate a multi-level Bill of Material (i.e. all level 1 
    -- components of a level 0 assembly, all level 2 components of a level 1 assembly)
    -- The CheckDate eliminates any components that are no longer used in the product on this date.
    WITH [BOM_cte]([ProductAssemblyID], [ComponentID], [ComponentDesc], [PerAssemblyQty], [StandardCost], [ListPrice], [BOMLevel], [RecursionLevel]) -- CTE name and columns
    AS (
        SELECT b.[ProductAssemblyID], b.[ComponentID], p.[Name], b.[PerAssemblyQty], p.[StandardCost], p.[ListPrice], b.[BOMLevel], 0 -- Get the initial list of components for the bike assembly
        FROM [Production].[BillOfMaterials] b
            INNER JOIN [Production].[Product] p 
            ON b.[ComponentID] = p.[ProductID] 
        WHERE b.[ProductAssemblyID] = @StartProductID 
            AND @CheckDate >= b.[StartDate] 
            AND @CheckDate <= ISNULL(b.[EndDate], @CheckDate)
        UNION ALL
        SELECT b.[ProductAssemblyID], b.[ComponentID], p.[Name], b.[PerAssemblyQty], p.[StandardCost], p.[ListPrice], b.[BOMLevel], [RecursionLevel] + 1 -- Join recursive member to anchor
        FROM [BOM_cte] cte
            INNER JOIN [Production].[BillOfMaterials] b 
            ON b.[ProductAssemblyID] = cte.[ComponentID]
            INNER JOIN [Production].[Product] p 
            ON b.[ComponentID] = p.[ProductID] 
        WHERE @CheckDate >= b.[StartDate] 
            AND @CheckDate <= ISNULL(b.[EndDate], @CheckDate)
        )
    -- Outer select from the CTE
    SELECT b.[ProductAssemblyID], b.[ComponentID], b.[ComponentDesc], SUM(b.[PerAssemblyQty]) AS [TotalQuantity] , b.[StandardCost], b.[ListPrice], b.[BOMLevel], b.[RecursionLevel]
    FROM [BOM_cte] b
    GROUP BY b.[ComponentID], b.[ComponentDesc], b.[ProductAssemblyID], b.[BOMLevel], b.[RecursionLevel], b.[StandardCost], b.[ListPrice]
    ORDER BY b.[BOMLevel], b.[ProductAssemblyID], b.[ComponentID]
    OPTION (MAXRECURSION 25) 
END;
GO
PRINT N'Dropping schemas'
GO
IF SCHEMA_ID(N'ref') IS NOT NULL
DROP SCHEMA [ref]
GO
