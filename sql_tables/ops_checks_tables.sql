USE [AdventureWorks2019]
GO

/****** Object:  Table [dbo].[ops_check_results_rerun]    Script Date: 1/16/2024 9:21:44 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ops_check_results_rerun](
	[ops_check_id] [int] NULL,
	[ops_check_count] [bigint] NULL,
	[flag_status] [bit] NULL,
	[rundate] [datetime] NULL
) ON [PRIMARY]
GO

USE [AdventureWorks2019]
GO

/****** Object:  Table [dbo].[ops_check_results]    Script Date: 1/16/2024 9:21:20 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ops_check_results](
	[ops_check_id] [int] NULL,
	[ops_check_count] [bigint] NULL,
	[flag_status] [bit] NULL,
	[rundate] [datetime] NULL
) ON [PRIMARY]
GO


USE [AdventureWorks2019]
GO

/****** Object:  Table [dbo].[ops_check]    Script Date: 1/16/2024 9:21:13 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ops_check](
	[ops_check_id] [int] IDENTITY(1,1) NOT NULL,
	[ops_check_desc] [nvarchar](600) NULL,
	[ops_check_category] [nvarchar](600) NULL,
	[ops_check_script_sp] [nvarchar](max) NULL,
	[expected_min] [float] NULL,
	[expected_max] [float] NULL,
	[ops_check_time] [int] NULL,
	[ops_check_update_date] [datetime] NOT NULL,
	[ops_check_update_by] [nvarchar](255) NULL,
	[ops_check_status] [float] NULL,
	[ops_check_documentation] [varchar](5000) NULL,
 CONSTRAINT [PK_gtb_dq_rules] PRIMARY KEY CLUSTERED 
(
	[ops_check_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO