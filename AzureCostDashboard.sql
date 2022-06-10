/****** Object:  Table [dbo].[AzureSecurity]    Script Date: 6/10/2022 9:50:06 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[AzureSecurity](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AzureId] [nvarchar](2000) NOT NULL,
	[UserName] [nvarchar](500) NOT NULL,
 CONSTRAINT [PK_AzureSecurity] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[BillingAccounts]    Script Date: 6/10/2022 9:50:08 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[BillingAccounts](
	[Id] [nvarchar](200) NULL,
	[Name] [nvarchar](250) NULL,
	[AccountId] [nvarchar](200) NULL,
	[AccountStatus] [nvarchar](50) NULL,
	[AccountType] [nvarchar](50) NULL,
	[AgreementType] [nvarchar](50) NULL,
	[DisplayName] [nvarchar](2000) NULL,
	[OrganizationId] [nvarchar](150) NULL
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[BillingSubscriptions]    Script Date: 6/10/2022 9:50:08 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[BillingSubscriptions](
	[AccountId] [nvarchar](200) NULL,
	[SubscriptionId] [nvarchar](36) NULL
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[BudgetAssociation]    Script Date: 6/10/2022 9:50:08 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[BudgetAssociation](
	[BudgetId] [nvarchar](2000) NULL,
	[AzureId] [nvarchar](2000) NULL
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Budgets]    Script Date: 6/10/2022 9:50:08 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Budgets](
	[Id] [nvarchar](2000) NULL,
	[Name] [nvarchar](50) NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[Amount] [float] NULL,
	[SubscriptionId] [nvarchar](36) NULL,
	[Manual] [bit] NULL
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Costs]    Script Date: 6/10/2022 9:50:09 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Costs](
	[ResourceId] [nvarchar](2000) NULL,
	[Cost] [decimal](18, 4) NULL,
	[CostUSD] [decimal](18, 4) NULL,
	[UsageDate] [int] NULL,
	[Currency] [nvarchar](5) NULL,
	[CreatedOn] [date] NULL
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[DataFlowCosts]    Script Date: 6/10/2022 9:50:09 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DataFlowCosts](
	[JsonResult] [nvarchar](max) NULL,
	[ResourceId] [nvarchar](2000) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[PriceLists]    Script Date: 6/10/2022 9:50:09 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[PriceLists](
	[CurrencyCode] [nvarchar](5) NULL,
	[TierMinimumUnits] [float] NULL,
	[RetailPrice] [float] NULL,
	[UnitPrice] [float] NULL,
	[Discount] [float] NULL,
	[ArmRegionName] [nvarchar](50) NULL,
	[Location] [nvarchar](500) NULL,
	[EffectiveStartDate] [datetime] NULL,
	[MeterId] [uniqueidentifier] NULL,
	[MeterName] [nvarchar](500) NULL,
	[ProductId] [nvarchar](500) NULL,
	[SkuId] [nvarchar](500) NULL,
	[ProductName] [nvarchar](500) NULL,
	[SkuName] [nvarchar](500) NULL,
	[ServiceName] [nvarchar](500) NULL,
	[ServiceId] [nvarchar](500) NULL,
	[ServiceFamily] [nvarchar](500) NULL,
	[UnitOfMeasure] [nvarchar](500) NULL,
	[Type] [nvarchar](500) NULL,
	[isPrimaryMeterRegion] [bit] NULL,
	[ArmSkuName] [nvarchar](500) NULL,
	[SubscriptionId] [nvarchar](36) NULL
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[ResourceGroups]    Script Date: 6/10/2022 9:50:09 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ResourceGroups](
	[Id] [nvarchar](500) NULL,
	[Name] [nvarchar](200) NULL,
	[Location] [nvarchar](50) NULL,
	[SubscriptionId] [nvarchar](36) NULL
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Resources]    Script Date: 6/10/2022 9:50:09 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Resources](
	[Id] [nvarchar](2000) NULL,
	[ResourceGroupId] [nvarchar](500) NULL,
	[Name] [nvarchar](500) NULL,
	[Type] [nvarchar](200) NULL,
	[Kind] [nvarchar](20) NULL,
	[Location] [nvarchar](50) NULL
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Subscriptions]    Script Date: 6/10/2022 9:50:09 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Subscriptions](
	[SubscriptionId] [nvarchar](36) NULL,
	[Path] [nvarchar](200) NULL,
	[AuthorizationSource] [nvarchar](50) NULL,
	[DisplayName] [nvarchar](500) NULL,
	[State] [nvarchar](50) NULL
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[UsageAggregates]    Script Date: 6/10/2022 9:50:09 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[UsageAggregates](
	[SubscriptionId] [uniqueidentifier] NULL,
	[UsageStartTime] [datetime] NULL,
	[UsageEndTime] [datetime] NULL,
	[MeterName] [nvarchar](200) NULL,
	[MeterCategory] [nvarchar](200) NULL,
	[MeterSubCategory] [nvarchar](200) NULL,
	[Unit] [nvarchar](20) NULL,
	[InstanceData] [nvarchar](max) NULL,
	[MeterId] [uniqueidentifier] NULL,
	[Quantity] [float] NULL,
	[ResourceUri] [nvarchar](2000) NULL,
	[Location] [nvarchar](50) NULL,
	[UsageDate] [date] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[Budgets] ADD  CONSTRAINT [DF_Budgets_Id]  DEFAULT (newid()) FOR [Id]
GO




/****** Object:  View [dbo].[BudgetResources]    Script Date: 6/10/2022 9:50:37 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[BudgetResources]
AS


SELECT DISTINCT BudgetId, ResourceId FROM (
	SELECT
		 b.Id AS BudgetId
		,r.Id AS ResourceId
	FROM 
		Budgets b
			INNER JOIN
		BudgetAssociation a
			ON b.Id = a.BudgetId
			INNER JOIN
		Subscriptions s
			ON a.AzureId = s.SubscriptionId
			INNER JOIN
		ResourceGroups rg 
			ON s.SubscriptionId = rg.SubscriptionId
			INNER JOIN
		Resources r
			ON r.ResourceGroupId = rg.Id
	UNION ALL
	SELECT
		b.Id AS BudgetId
		,r.Id AS ResourceId
	FROM 
		Budgets b
			INNER JOIN
		BudgetAssociation a
			ON b.Id = a.BudgetId
			INNER JOIN
		ResourceGroups rg 
			ON a.AzureId = rg.Id
			INNER JOIN
		Resources r
			ON r.ResourceGroupId = rg.Id
	UNION ALL
	SELECT
		b.Id AS BudgetId
		,r.Id AS ResourceId
	FROM 
		Budgets b
			INNER JOIN
		BudgetAssociation a
			ON b.Id = a.BudgetId
			INNER JOIN
		Resources r
			ON a.AzureId = r.Id
) x

GO

/****** Object:  View [dbo].[BudgetCosts]    Script Date: 6/10/2022 9:50:37 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [dbo].[BudgetCosts]
AS


SELECT DISTINCT
	 b.Id AS BudgetId
	,r.Name AS ResourceName
	,r.Type AS ResourceType
	,r.Kind AS ResourceKind
	,r.Location AS ResourceLocation
	,rg.Name AS ResourceGroupName
	,c.*
FROM 
	Budgets b
		INNER JOIN
	BudgetResources br
		ON b.Id = br.BudgetId
		INNER JOIN
	Costs c
		ON br.ResourceId = c.ResourceId
			AND c.CreatedOn >= b.StartDate 
			AND c.CreatedOn <= b.EndDate
		INNER JOIN
	Resources r
		ON c.ResourceId = r.Id
		INNER JOIN
	ResourceGroups rg
		ON r.ResourceGroupId = rg.Id

GO





/****** Object:  StoredProcedure [dbo].[spCreateBudget]    Script Date: 6/10/2022 9:51:02 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      Planet Technologies
-- Create Date: 6/9/2022
-- Description: Creates a new budgets and associates it with a resource
-- =============================================
CREATE PROCEDURE [dbo].[spCreateBudget]
(
    -- Add the parameters for the stored procedure here
    @Name NVARCHAR(50),
	@StartDate DATETIME,
	@EndDate DATETIME,
	@Amount FLOAT,
	@AzureName NVARCHAR(2000)
)
AS
BEGIN
    SET NOCOUNT ON

	DECLARE @SubscriptionId NVARCHAR(2000)
	DECLARE @AzureId NVARCHAR(2000)

	SELECT @SubscriptionId = SubscriptionId, @AzureId = SubscriptionId FROM Subscriptions WHERE SubscriptionId = @AzureName OR DisplayName = @AzureName

	IF @SubscriptionId IS NULL BEGIN
		SELECT @SubscriptionId = SubscriptionId, @AzureId = Id FROM ResourceGroups WHERE Id = @AzureName OR Name = @AzureName
	END
    
	-- Insert statements for procedure here
    INSERT INTO Budgets (Id, Name, StartDate, EndDate, Amount, SubscriptionId, Manual)
	VALUES (@Name, @Name, @StartDate, @EndDate, @Amount, @SubscriptionId, 1)

	INSERT INTO BudgetAssociation (BudgetId, AzureId)
	VALUES (@Name, @AzureId)
END
GO

/****** Object:  StoredProcedure [dbo].[spInsertDataFlowCost]    Script Date: 6/10/2022 9:51:02 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spInsertDataFlowCost]
(
    @ResourceId NVARCHAR(2000),
	@CostData NVARCHAR(MAX)
)
AS
BEGIN
    SET NOCOUNT ON
    INSERT INTO DataFlowCosts (JsonResult, ResourceId)
	VALUES (@CostData, @ResourceId)

	SELECT 1 AS COMPLETED
END
GO


