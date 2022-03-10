SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
PRINT N'Dropping index [AK_Dept_Name] from [HumanResources].[Department]'
GO
DROP INDEX [AK_Dept_Name] ON [HumanResources].[Department]
GO
PRINT N'Altering [dbo].[InsertUpdate]'
GO
-- =============================================
-- Author:		Anirban
-- Create date: 2020-03-10
-- Description:	Procedure to insert and update Department data 
-- =============================================
ALTER   procedure [dbo].[InsertUpdate]	  
(   
   @dept_id INTEGER = NULL,
   @name NVARCHAR(100),  
   @groupname NVARCHAR(100),  
   @moddate DATETIME,
   @StatementType nvarchar(20) = ''
)   
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

	BEGIN TRY
 
		IF @StatementType = 'Insert'  
			BEGIN  
			insert into [HumanResources].[Department]([Name],[GroupName],[ModifiedDate]) values( @name, @groupname, @moddate)  
			END  
		IF @StatementType = 'Select'  
			BEGIN  
			select TOP (10) [DepartmentID],[Name],[GroupName],[ModifiedDate]from [HumanResources].[Department]  
			END  
		IF @StatementType = 'Update'  
			BEGIN  
			UPDATE [HumanResources].[Department] SET  
			[Name] = @name, [GroupName] = @groupname, [ModifiedDate] = @moddate
			WHERE [DepartmentID] = @dept_id  
			END  

	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		return -1
	END CATCH
END
GO
PRINT N'Refreshing [HumanResources].[vEmployeeDepartment]'
GO
EXEC sp_refreshview N'[HumanResources].[vEmployeeDepartment]'
GO
PRINT N'Refreshing [HumanResources].[vEmployeeDepartmentHistory]'
GO
EXEC sp_refreshview N'[HumanResources].[vEmployeeDepartmentHistory]'
GO
PRINT N'Creating index [AK_Department_Id] on [HumanResources].[Department]'
GO
CREATE NONCLUSTERED INDEX [AK_Department_Id] ON [HumanResources].[Department] ([DepartmentID])
GO
