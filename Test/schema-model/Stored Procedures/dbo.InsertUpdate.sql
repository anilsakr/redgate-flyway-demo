SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Anirban
-- Create date: 2020-03-10
-- Description:	Procedure to insert and update Department data 
-- =============================================
CREATE   procedure [dbo].[InsertUpdate]	  
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
