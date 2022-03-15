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
PRINT N'Dropping [dbo].[InsertUpdate]'
GO
DROP PROCEDURE [dbo].[InsertUpdate]
GO
PRINT N'Dropping schemas'
GO
IF SCHEMA_ID(N'ref') IS NOT NULL
DROP SCHEMA [ref]
GO
