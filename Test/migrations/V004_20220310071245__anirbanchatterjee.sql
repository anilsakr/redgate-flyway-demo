SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
PRINT N'Dropping extended properties'
GO
EXEC sp_dropextendedproperty N'MS_Description', 'SCHEMA', N'HumanResources', 'TABLE', N'Department', 'INDEX', N'AK_Department_Name'
GO
PRINT N'Dropping index [AK_Department_Name] from [HumanResources].[Department]'
GO
DROP INDEX [AK_Department_Name] ON [HumanResources].[Department]
GO
PRINT N'Dropping [dbo].[ChrisSproc]'
GO
DROP PROCEDURE [dbo].[ChrisSproc]
GO
PRINT N'Dropping [dbo].[PersonSPROC]'
GO
DROP PROCEDURE [dbo].[PersonSPROC]
GO
PRINT N'Creating [dbo].[InsertUpdate]'
GO
create procedure [dbo].[InsertUpdate]  
(   
   @dept_id INTEGER = NULL,
   @name NVARCHAR(100),  
   @groupname NVARCHAR(100),  
   @moddate DATETIME,
   @StatementType nvarchar(20) = ''
)  
AS  
BEGIN  
IF @StatementType = 'Insert'  
BEGIN  
insert into [HumanResources].[Department]([Name],[GroupName],[ModifiedDate]) values( @name, @groupname, @moddate)  
END  
IF @StatementType = 'Select'  
BEGIN  
select TOP (100) [DepartmentID],[Name],[GroupName],[ModifiedDate]from [HumanResources].[Department]  
END  
IF @StatementType = 'Update'  
BEGIN  
UPDATE [HumanResources].[Department] SET  
[Name] = @name, [GroupName] = @groupname, [ModifiedDate] = @moddate
WHERE [DepartmentID] = @dept_id  
END  
end  



exec InsertUpdate
@name = 'Blast Furnace',  
@groupname = 'Manufacturing',  
@moddate = '2008-04-30 00:00:00.000',
@StatementType = 'Insert'
GO
PRINT N'Refreshing [HumanResources].[vEmployeeDepartment]'
GO
EXEC sp_refreshview N'[HumanResources].[vEmployeeDepartment]'
GO
PRINT N'Refreshing [HumanResources].[vEmployeeDepartmentHistory]'
GO
EXEC sp_refreshview N'[HumanResources].[vEmployeeDepartmentHistory]'
GO
PRINT N'Creating [dbo].[AddressType]'
GO
CREATE TABLE [dbo].[AddressType]
(
[column1] [tinyint] NOT NULL,
[column2] [nvarchar] (50) NOT NULL,
[column3] [nvarchar] (50) NOT NULL,
[column4] [datetime2] NOT NULL
)
GO
PRINT N'Creating [dbo].[Address]'
GO
CREATE TABLE [dbo].[Address]
(
[column1] [smallint] NOT NULL,
[column2] [nvarchar] (50) NOT NULL,
[column3] [nvarchar] (50) NULL,
[column4] [nvarchar] (50) NOT NULL,
[column5] [tinyint] NOT NULL,
[column6] [nvarchar] (50) NOT NULL,
[column7] [nvarchar] (50) NOT NULL,
[column8] [nvarchar] (50) NOT NULL,
[column9] [nvarchar] (50) NOT NULL
)
GO
PRINT N'Creating index [AK_Dept_Name] on [HumanResources].[Department]'
GO
CREATE NONCLUSTERED INDEX [AK_Dept_Name] ON [HumanResources].[Department] ([DepartmentID])
GO
PRINT N'Adding constraints to [Production].[Document]'
GO
ALTER TABLE [Production].[Document] ADD CONSTRAINT [UQ__Document__F73921F7751EE450] UNIQUE NONCLUSTERED ([rowguid])
GO
