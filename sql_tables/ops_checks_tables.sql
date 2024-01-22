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
/****** Object:  Table [dbo].[ops_check]    Script Date: 1/22/2024 5:35:31 AM ******/
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
SET IDENTITY_INSERT [dbo].[ops_check] ON 

INSERT [dbo].[ops_check] ([ops_check_id], [ops_check_desc], [ops_check_category], [ops_check_script_sp], [expected_min], [expected_max], [ops_check_time], [ops_check_update_date], [ops_check_update_by], [ops_check_status], [ops_check_documentation]) VALUES (7, N'incorrect order', N'orders', N'select 7 as ops_check_id, 1 as result,getdate() as date', 0, 0, 7, CAST(N'2024-01-09T00:00:00.000' AS DateTime), N'lazlo', 1, N'check documentation')
INSERT [dbo].[ops_check] ([ops_check_id], [ops_check_desc], [ops_check_category], [ops_check_script_sp], [expected_min], [expected_max], [ops_check_time], [ops_check_update_date], [ops_check_update_by], [ops_check_status], [ops_check_documentation]) VALUES (8, N'order mismatch', N'orders', N'select 8 as ops_check_id, 2 as result,getdate() as date', 5, 10, 8, CAST(N'2024-01-09T00:00:00.000' AS DateTime), N'lazlo', 1, N'check documentation')
INSERT [dbo].[ops_check] ([ops_check_id], [ops_check_desc], [ops_check_category], [ops_check_script_sp], [expected_min], [expected_max], [ops_check_time], [ops_check_update_date], [ops_check_update_by], [ops_check_status], [ops_check_documentation]) VALUES (9, N'missing order', N'orders', N'test_sp3', -300, 300, 9, CAST(N'2024-01-09T00:00:00.000' AS DateTime), N'lazlo', 1, N'check documentation')
INSERT [dbo].[ops_check] ([ops_check_id], [ops_check_desc], [ops_check_category], [ops_check_script_sp], [expected_min], [expected_max], [ops_check_time], [ops_check_update_date], [ops_check_update_by], [ops_check_status], [ops_check_documentation]) VALUES (10, N'incomplete settlement', N'settlement', N'test_sp4', -20, 20, 10, CAST(N'2024-01-09T00:00:00.000' AS DateTime), N'lazlo', 1, N'check documentation')
INSERT [dbo].[ops_check] ([ops_check_id], [ops_check_desc], [ops_check_category], [ops_check_script_sp], [expected_min], [expected_max], [ops_check_time], [ops_check_update_date], [ops_check_update_by], [ops_check_status], [ops_check_documentation]) VALUES (11, N'duplicate settlement', N'settlement', N'select 11 as ops_check_id, 5 as result,getdate() as date', 0, 300, 11, CAST(N'2024-01-09T00:00:00.000' AS DateTime), N'lazlo', 1, N'check documentation')
INSERT [dbo].[ops_check] ([ops_check_id], [ops_check_desc], [ops_check_category], [ops_check_script_sp], [expected_min], [expected_max], [ops_check_time], [ops_check_update_date], [ops_check_update_by], [ops_check_status], [ops_check_documentation]) VALUES (12, N'desc6', N'category6', N'test_sp6', 0, 0, 7, CAST(N'2024-01-09T00:00:00.000' AS DateTime), N'lazlo', 0, N'check documentation')
INSERT [dbo].[ops_check] ([ops_check_id], [ops_check_desc], [ops_check_category], [ops_check_script_sp], [expected_min], [expected_max], [ops_check_time], [ops_check_update_date], [ops_check_update_by], [ops_check_status], [ops_check_documentation]) VALUES (13, N'settlement mismatch', N'settlement', N'select 13 as ops_check_id, 1/0 as result,getdate() as date', 0, 0, 7, CAST(N'2024-01-09T00:00:00.000' AS DateTime), N'lazlo', 1, N'check documentation')
SET IDENTITY_INSERT [dbo].[ops_check] OFF
GO

	[ops_check_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
