USE [AdventureWorks2019]
GO

/****** Object:  StoredProcedure [dbo].[test_sp3]    Script Date: 1/16/2024 9:23:50 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


    
CREATE PROCEDURE [dbo].[test_sp3] 
AS
BEGIN

select 9 as ops_check_id, 1000 as result, getdate() as date

END
GO

USE [AdventureWorks2019]
GO

/****** Object:  StoredProcedure [dbo].[test_sp4]    Script Date: 1/16/2024 9:24:43 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


    
CREATE PROCEDURE [dbo].[test_sp4] 
AS
BEGIN

select 10 as ops_check_id, -10 as result, getdate() as date

END
GO

USE [AdventureWorks2019]
GO

/****** Object:  StoredProcedure [dbo].[test_sp6]    Script Date: 1/16/2024 9:25:03 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


    
CREATE PROCEDURE [dbo].[test_sp6] 
AS
BEGIN

select 12 as ops_check_id, 1 as result, getdate() as date

END
GO