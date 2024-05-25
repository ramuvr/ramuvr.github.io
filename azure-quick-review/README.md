# Azure Quick Review
- [Azure Quick Review](#azure-quick-review)
  - [Usage](#usage)
  - [Available Commands](#available-commands)
  - [Flags supported](#flags-supported)
  - [References](#references)

Azure Quick Review (azqr) is a command-line interface (CLI) tool specifically designed to analyze Azure resources and identify whether they comply with Azure’s best practices and recommendations. Its primary purpose is to provide users with a detailed overview of their Azure resources, enabling them to easily identify any non-compliant configurations or potential areas for improvement.

The executable is setup to run on a schedule using DevOps Pipeline and capture results in the repo for reference. Azure Devops Pipeline uses Entra ID service principal using [Workload Identity](https://devblogs.microsoft.com/devops/introduction-to-azure-devops-workload-identity-federation-oidc-with-terraform/) for accessing Azure subscriptions using `Reader` role at the `Tenant Root Group` management group.

## Usage 
```cmd
azqr scan [flags]
an [command]
```
## Available Commands
```txt
Available Commands:
  adf         Scan Azure Data Factory
  afd         Scan Azure Front Door
  afw         Scan Azure Firewall
  agw         Scan Azure Application Gateway
  aks         Scan Azure Kubernetes Service
  amg         Scan Azure Managed Grafana
  apim        Scan Azure API Management
  appcs       Scan Azure App Configuration
  appi        Scan Azure Application Insights
  as          Scan Azure Analysis Service
  asp         Scan Azure App Service
  ca          Scan Azure Container Apps
  cae         Scan Azure Container Apps Environment
  ci          Scan Azure Container Instances
  cog         Scan Azure Cognitive Service Accounts
  cosmos      Scan Azure Cosmos DB
  cr          Scan Azure Container Registries
  dbw         Scan Azure Databricks
  dec         Scan Azure Data Explorer
  evgd        Scan Azure Event Grid Domains
  evh         Scan Azure Event Hubs
  kv          Scan Azure Key Vault
  lb          Scan Azure Load Balancer
  logic       Scan Azure Logic Apps
  maria       Scan Azure Database for MariaDB
  mysql       Scan Azure Database for MySQL
  psql        Scan Azure Database for psql
  redis       Scan Azure Cache for Redis
  sb          Scan Azure Service Bus
  sigr        Scan Azure SignalR
  sql         Scan Azure SQL Database
  st          Scan Azure Storage
  synw        Scan Azure Synapse Workspace
  traf        Scan Azure Traffic Manager
  vgw         Scan Virtual Network Gateway
  vm          Scan Virtual Machine
```

## Flags supported
```txt
Flags:
  -a, --advisor                  Scan Azure Advisor Recommendations (default true)
  -f, --azure-cli-credential     Force the use of Azure CLI Credential
  -c, --costs                    Scan Azure Costs
      --debug                    Set log level to debug
  -d, --defender                 Scan Defender Status (default true)
  -x, --excel                    Create excel report
  -e, --exclusions string        Exclusions file (YAML format)
  -h, --help                     help for scan
  -m, --mask                     Mask the subscription id in the report (default true)
  -o, --output-name string       Output file name without extension
  -g, --resource-group string    Azure Resource Group (Use with --subscription-id)
  -s, --subscription-id string   Azure Subscription Id

 scan [command] --help" for more information about a command.
```

## References
- [Azure Quick Review](https://azure.github.io/azqr/)
- [Azure Quick Review Repo](https://github.com/azure/azqr)
- [Azure DevOps Pipelines](https://learn.microsoft.com/en-us/azure/devops/pipelines/get-started/what-is-azure-pipelines?view=azure-devops)