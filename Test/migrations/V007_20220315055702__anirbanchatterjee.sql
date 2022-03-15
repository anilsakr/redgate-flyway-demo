SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
PRINT N'Creating schemas'
GO
IF SCHEMA_ID(N'ref') IS NULL
EXEC sp_executesql N'CREATE SCHEMA [ref]
AUTHORIZATION [admin]'
GO
PRINT N'Creating [ref].[Barlines]'
GO
CREATE TABLE [ref].[Barlines]
(
[BarlineID] [nvarchar] (255) NOT NULL,
[BarlineName] [nvarchar] (255) NULL,
[PlaneType] [float] NULL,
[MinorModel] [nvarchar] (255) NULL,
[Airstair] [bit] NULL,
[Model] [nvarchar] (255) NULL,
[Day] [int] NOT NULL,
[Shift] [int] NULL,
[Position] [nvarchar] (255) NULL,
[NumStations] [int] NULL,
[AreaID] [nvarchar] (50) NOT NULL,
[SubAreaID] [nvarchar] (50) NOT NULL,
[NumberMechanics] [int] NOT NULL,
[CreatedOn] [datetime2] NULL,
[CreatedBy] [nvarchar] (255) NULL,
[ModifiedOn] [datetime2] NULL,
[ModifiedBy] [nvarchar] (255) NULL,
[Line] [varchar] (10) NULL,
[description] [varchar] (255) NOT NULL CONSTRAINT [DF__Barlines__descri__658C0CBD] DEFAULT ('NA')
)
GO
PRINT N'Creating primary key [PK__Barlines__A04047B59155B95C] on [ref].[Barlines]'
GO
ALTER TABLE [ref].[Barlines] ADD CONSTRAINT [PK__Barlines__A04047B59155B95C] PRIMARY KEY CLUSTERED ([BarlineID])
GO
PRINT N'Creating [ref].[BuildPlanJobs]'
GO
CREATE TABLE [ref].[BuildPlanJobs]
(
[JobID] [int] NOT NULL,
[JobName] [nvarchar] (50) NULL,
[JobDescription] [nvarchar] (100) NULL,
[MinorModel] [nvarchar] (50) NULL,
[AirStair] [bit] NULL,
[CanTravel] [bit] NULL,
[ProfitCenter] [int] NULL,
[CostCenter] [nvarchar] (50) NULL,
[WC] [nvarchar] (50) NULL,
[WorkCenter] [nvarchar] (50) NULL,
[ACC] [int] NULL,
[FabAssemblyFlag] [nvarchar] (50) NOT NULL,
[AreaID] [nvarchar] (50) NULL,
[SubAreaID] [nvarchar] (50) NULL,
[Substation] [nvarchar] (255) NULL,
[Part_Family] [nvarchar] (50) NULL,
[ProcessType] [nvarchar] (50) NULL,
[Standards] [float] NULL,
[JobExpectedDurationInMin] [float] NOT NULL,
[LaborGrade] [nvarchar] (50) NULL,
[JobCode] [nvarchar] (50) NULL,
[SINumber] [nvarchar] (50) NULL,
[Operation_Fab] [int] NULL,
[MaterialNumber] [nvarchar] (50) NULL,
[MaterialDesc] [nvarchar] (50) NULL,
[NumberMechanics] [int] NOT NULL,
[CriticalPath] [nvarchar] (50) NULL,
[CreatedOn] [datetime2] NULL,
[CreatedBy] [nvarchar] (50) NULL,
[ModifiedOn] [datetime2] NULL,
[ModifiedBy] [nvarchar] (50) NULL,
[DispatchDay] [int] NULL,
[RFIDFlag] [bit] NULL,
[CriticalStageGate] [nvarchar] (10) NULL,
[SpatialConstraintJobIDs] [varchar] (255) NULL,
[Line] [varchar] (10) NULL,
[ConcurrentJobIDs] [varchar] (255) NULL,
[Shift] [int] NULL,
[description] [varchar] (255) NOT NULL CONSTRAINT [DF__BuildPlan__descr__668030F6] DEFAULT ('NA')
)
GO
PRINT N'Creating primary key [PK__BuildPla__056690E27CF2D7E0_OLD] on [ref].[BuildPlanJobs]'
GO
ALTER TABLE [ref].[BuildPlanJobs] ADD CONSTRAINT [PK__BuildPla__056690E27CF2D7E0_OLD] PRIMARY KEY CLUSTERED ([JobID])
GO
PRINT N'Altering [dbo].[uspGetBillOfMaterials]'
GO


ALTER   PROCEDURE [dbo].[uspGetBillOfMaterials]
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
    OPTION (MAXRECURSION 20) 
END;
GO
