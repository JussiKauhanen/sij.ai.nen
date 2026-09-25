# infra/azure

Bicep skeleton. Region: `swedencentral`. Check whether a Finland region is available for your subscription when you deploy.

Planned resources: Functions (webhook, detector, drafter), Service Bus (transcript queue), Cosmos DB (state + approval audit log), Key Vault (secrets), Azure OpenAI / AI Foundry (LLM), Azure AI Search (index for Confluence / Jira), Notification Hubs (push). SharePoint and OneDrive are searched through Microsoft Graph as the user. Bot registration via Azure Bot Service + Entra ID app if you move off a bot vendor.

```bash
cd infra/azure
az group create -n rg-sijainen-dev -l swedencentral
az deployment group create -g rg-sijainen-dev -f main.bicep -p main.parameters.json
```
