targetScope = 'resourceGroup'

@description('Deployment region')
param location string = resourceGroup().location

@allowed([ 'dev', 'prod' ])
param env string = 'dev'

var prefix = 'sijainen-${env}'
var tags = {
  project: 'sijainen'
  env: env
}

// TODO: webhook + detector - Microsoft.Web/sites (Function App) + App Service plan
// TODO: queue              - Microsoft.ServiceBus/namespaces + queue 'transcripts'
// TODO: state              - Microsoft.DocumentDB/databaseAccounts (Cosmos DB, serverless)
// TODO: secrets            - Microsoft.KeyVault/vaults
// TODO: llm                - Microsoft.CognitiveServices/accounts (kind: OpenAI)
// TODO: push               - Microsoft.NotificationHubs/namespaces
// TODO: bot (later)        - Microsoft.BotService/botServices + Entra ID app registration

output prefix string = prefix
output tags object = tags
