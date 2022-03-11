INSERT INTO [HumanResources].[Department]
           ([Name]
           ,[GroupName]
           ,[ModifiedDate])
     VALUES
           ('Logistic', 'Supply Chain Management', SYSDATETIME()),
		   ('SKU', 'Inventory Management', SYSDATETIME())
GO



UPDATE [HumanResources].[Department]
SET [Name] = 'Director', [GroupName] = 'Research and Development' WHERE [DepartmentID] = 22 
GO