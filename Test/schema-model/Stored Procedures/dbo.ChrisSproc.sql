SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
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
