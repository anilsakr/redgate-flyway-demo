SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
PRINT N'Creating [dbo].[ChrisSproc]'
GO
--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF
--GO
CREATE PROCEDURE [dbo].[ChrisSproc]
-- WITH ENCRYPTION, RECOMPILE, EXECUTE AS CALLER|SELF|OWNER| 'user_name'
AS
BEGIN
    SELECT BusinessEntityID,
           PersonType,
           NameStyle,
           Title,
           FirstName,
           MiddleName,
           LastName,
           Suffix,
           EmailPromotion,
           AdditionalContactInfo,
           Demographics,
           rowguid,
           ModifiedDate FROM [Person].[Person]
END
GO
