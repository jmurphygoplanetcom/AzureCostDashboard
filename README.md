# _Azure Cost Dashboard_

# Summary
The GitHub project contains artifacts to aggregate Azure Consumption data into a Managed SQL instance using data factory pipelines and a PowerBI report to show the costs and billing data from Azure.  All data will be updated once a day and presented through PowerBi for analysis and review.


# Setup and Installation
### Prerequisites 
- Azure SQL Server
- - Ensure that your Azure SQL Server has either full access by tenant azure resources OR firewall access to Azure Data Factory runtime IP address(es)
- - Create SQL login/password with owner DB permissions
- Azure Key Vault
- Permissions to create service principle
- Permissions to assign RBAC
### Azure Setup
The first thing which needs to be done is to setup a service principle which azure data factory will use to query the tenant. Steps to create the service principle can be found in this Microsoft document (Make sure to note eh client id and secret as you will need these for later steps).

https://docs.microsoft.com/en-us/azure/active-directory/develop/howto-create-service-principal-portal

Assign your service principal permissions to Azure Management API.

Once the service principle is created it will need to be given roles for read permissions across all azure resources at the billing account, as well as billing reader permissions. The process to assign roles to a service principle can be found in the following Microsoft article.

https://docs.microsoft.com/en-us/azure/role-based-access-control/role-assignments-steps 

Next, in Azure Key Value you will need to setup 2 new secrets. One containing the newly created client id of your service principle; the other containing the secret of the service principle.
https://docs.microsoft.com/en-us/azure/key-vault/secrets/quick-create-portal 

After creating the two secrets make sure to copy both secret identifier URLs as you will need these for deployment.
https://docs.microsoft.com/en-us/azure/key-vault/general/about-keys-secrets-certificates#objects-identifiers-and-versioning 

Deployment of the resources will be through an Azure ARM template. The published arm template will be located temporarily on GITHUB at: 
https://github.com/jmurphygoplanetcom/AzureCostDashboard/tree/adf_publish
This Azure ARM Template will have a permanent location at a future date after this project is finalized.

### Installation

After standing up a new data factory instance create the following global parameters:
- "tenantId" - (string) The GUID of the Azure Tenant
- "azurekeyvault_client_secret_secretidentifier" - (string) The URL provided by azure key vault for the secret identifier. Note: Please append ?api-version=7.0 at the end of the url.
- "azurekeyvault_client_id_secretidentifier" - (string) The URL provided by azure key vault for the id identifier. Note: Please append ?api-version=7.0 at the end of the url.

Create the following linked services to your Azure Resources:
- "AzureKeyVault" (Azure Key Vault)
- "AzureManagementApi" (HTTP) Base url will be "https://management.azure.com/"; type will be "Anonymous"
- "DashboardSQLService" (Azure SQL Database)

Deploy the arm template.
https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/quickstart-create-templates-use-the-portal

The published ARM template will be found at GITHUB (final URL TBD)
https://github.com/jmurphygoplanetcom/AzureCostDashboard/tree/adf_publish 

Note: The following is a list of parameters you will need to assign during deployment.
- Linked SQL Server
- Azure key vault secret identifier client id URL
- Azure key vault secret identifier client secret URL 


# SQL Design

Azure SQL Server will store a limited extract of data from the Azure Management, Consumption, and Usage APIs. The following diagrams show the tables extracted and their relationships to one another.

 
```sh
TABLE [BillingAccounts](
	[Id] [uniqueidentifier] NOT NULL
	[AccountStatus] [nvarchar](50) NULL
	[AccountType] [nvarchar](50) NULL
	[AgreementType] [nvarchar](50) NULL
	[CompanyName] [nvarchar](50) NULL
	[Country] [nvarchar](5) NULL
	[Email] [nvarchar](500) NULL
	[FirstName] [nvarchar](255) NULL
	[LastName] [nvarchar](255) NULL
	[PhoneNumber] [nvarchar](50) NULL

TABLE [Costs]
	[ResourceId] [nvarchar](2000) NULL
	[Cost] [decimal](18 4) NULL
	[CostUSD] [decimal](18 4) NULL
	[UsageDate] [int] NULL
	[Currency] [nvarchar](5) NULL

TABLE [DataFlowCosts]
	[JsonResult] [nvarchar](MAX) NULL
	[ResourceId] [nvarchar](2000) NULL

TABLE [ResourceGroups]
	[Id] [nvarchar](500) NULL
	[SubscriptionId] [uniqueidentifier] NULL
	[Name] [nvarchar](200) NULL
	[Location] [nvarchar](50) NULL

TABLE [Resources](
	[Id] [nvarchar](2000) NULL
	[ResourceGroupId] [nvarchar](500) NULL
	[Name] [nvarchar](500) NULL
	[Type] [nvarchar](200) NULL
	[Kind] [nvarchar](20) NULL
	[Location] [nvarchar](50) NULL

TABLE [Subscriptions]
	[Id] [uniqueidentifier] NOT NULL
	[BillingAccountId] [uniqueidentifier] NOT NULL
	[Path] [nvarchar](200) NULL
	[AuthorizationSource] [nvarchar](50) NULL
	[SubscriptionId] [nvarchar](36) NULL
	[DisplayName] [nvarchar](500) NULL
	[State] [nvarchar](50) NULL
```


# Azure Data Factory
The Azure data factory will leverage the management, consumption, and usage APIs to pull cost related data associated to the organization’s tenant. The following is the general order of operations performed by the data factory job.
1.	Retrieve Billing Accounts – Copies a list of the tenant’s billing accounts into SQL
https://docs.microsoft.com/en-us/rest/api/billing/2019-10-01-preview/billing-accounts/list

2.	Retrieve Subscriptions associated to each Billing Account
https://docs.microsoft.com/en-us/rest/api/resources/subscriptions/list


3.	Retrieve Resource Groups associated to each Subscription
https://docs.microsoft.com/en-us/rest/api/resources/resource-groups/list 

4.	Retrieve Resources associated to each Resource Group 
https://docs.microsoft.com/en-us/rest/api/resources/resources/list

5.	Retrieve Costs associated to each Resource – Dimensions are set within the API callout to retrieve daily consumption rates per resource. 
Important! List of Unsupported Subscription Types
-MS-AZR-0145P (CSP)
MS-AZR-0146P (CSP)
MS-AZR-159P (CSP)
MS-AZR-0036P (sponsored)
MS-AZR-0143P (sponsored)
MS-AZR-0015P (internal)
MS-AZR-0144P (DreamSpark)
For the above subscription types the cost will always return as zero. To accommodate these subscriptions, we run the following step to try and pull aggregate costs from the subscription.
https://docs.microsoft.com/en-us/rest/api/cost-management/query/usage 

6.	Retrieve UsageAggregates for Sponsorship and CSP subscriptions
https://docs.microsoft.com/en-us/azure-stack/operator/azure-stack-tenant-resource-usage-api?view=azs-2108 

# Additional Data Flow
The cost management queries return an array of data which isn’t condusive to being directly populated within the SQL database. To accommodate this, we use an Azure Data Factory Data Flow.

![Dataflow](/images/Dataflow1.png)

(Sample of cost data)
```json
{
    "id": "subscriptions/89e6ade6-e91a-4152-bf83-9c83a3cb6ae3/resourcegroups/JamesGeneralDevelopment/providers/Microsoft.CostManagement/query/45ee17fd-7b46-4013-8237-1651a4050a41",
    "name": "45ee17fd-7b46-4013-8237-1651a4050a41",
    "type": "Microsoft.CostManagement/query",
    "location": null,
    "sku": null,
    "eTag": null,
    "properties": {
        "nextLink": null,
        "columns": [
            {
                "name": "Cost",
                "type": "Number"
            },
            {
                "name": "CostUSD",
                "type": "Number"
            },
            {
                "name": "UsageDate",
                "type": "Number"
            },
            {
                "name": "Currency",
                "type": "String"
            }
        ],
        "rows": [
            [
                0.00055245,
                0.00055245,
                20220302,
                "USD"
            ],
            [
                0.00051815,
                0.00051815,
                20220303,
                "USD"
            ],
            [
                0.0004336,
                0.0004336,
                20220304,
                "USD"
            ],
            [
                0.00043375,
                0.00043375,
                20220305,
                "USD"
            ],
            [
                0.00043405,
                0.00043405,
                20220306,
                "USD"
            ],
            [
                0.0004313,
                0.0004313,
                20220307,
                "USD"
            ],
            [
                0.00043355,
                0.00043355,
                20220308,
                "USD"
            ],
            [
                0.0004332,
                0.0004332,
                20220309,
                "USD"
            ],
            [
                0.0004325,
                0.0004325,
                20220310,
                "USD"
            ],
            [
                0.00043385,
                0.00043385,
                20220311,
                "USD"
            ],
            [
                0.00043365,
                0.00043365,
                20220312,
                "USD"
            ],
            [
                0.0004339,
                0.0004339,
                20220313,
                "USD"
            ],
            [
                0.00043345,
                0.00043345,
                20220314,
                "USD"
            ],
            [
                0.0004253,
                0.0004253,
                20220315,
                "USD"
            ],
            [
                0.0004335,
                0.0004335,
                20220316,
                "USD"
            ],
            [
                0.0004336,
                0.0004336,
                20220317,
                "USD"
            ],
            [
                0.0004337,
                0.0004337,
                20220318,
                "USD"
            ],
            [
                0.00043365,
                0.00043365,
                20220319,
                "USD"
            ],
            [
                0.00043375,
                0.00043375,
                20220320,
                "USD"
            ],
            [
                0.0003795,
                0.0003795,
                20220321,
                "USD"
            ]
        ]
    }
}
```


 
-	DataFlowCosts: Extracts the raw JSON data
-	Parse: Parses the JSON into a schema
-	Flatten: Flattens the cost array into a workable dataset
-	Derived Column: Extracts each array position as a cost column
-	Costs: Sink return set for the parsed data

# Budgets
Budgets can be created to compare and measure costs of a subscription and one or more resource groups. To create a new budget execute the following SQL script.

```sql
--Create a new budget
EXEC spCreateBudget 'My New Budget', '6/1/2022', '6/1/2023', 17.00, 'James Murphy – MPN'

PROCEDURE spCreateBudget
(
	-- Unique name of the budget
	@Name NVARCHAR(50),
	-- Start time for measurement of the budget
	@StartDate DATETIME,
	-- End time for measurement of the budget
	@EndDate DATETIME,
	-- Amount to include in the budget
	@Amount FLOAT,
	-- Name of the subscription, resource group, or resource to include in the budget
	@AzureName NVARCHAR(2000)
)
```

# PowerBI Design
The PowerBi report will display cost management data and enable viewing of data by resource group, billing account and subscriptions.  The report will provide a list view with filters and graphs for data visualization.

![Dashboard](/images/Dashboard1.png)

![Dashboard](/images/Dashboard2.png)

![Dashboard](/images/Dashboard3.png)

![Dashboard](/images/Dashboard4.png)

![Dashboard](/images/Dashboard5.png)

![Dashboard](/images/Dashboard6.png)

![Dashboard](/images/Dashboard7.png)

