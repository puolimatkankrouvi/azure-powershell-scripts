# Azure powershell scripts that I use

### Creating new web app (optionally resource group and app service plan)
    ./NewWebapp.ps1 -Name "foo_webapp" -ResourceGroupName "foo_resourcegroup" -ServicePlanName "foo_serviceplan" [-CreateNewResourceGroup] [-CreateNewServicePlan]

### Cleaning web app and/or app service plan
    ./CleanWebApp.ps1 -ResourceGroupName "foo_resourcegroup" [-Name "foo_webapp"] [-ServicePlanName "foo_serviceplan"]

### Add azure alert
    ./NewAzAlert.ps1 -ResourceGroupName "foo_resourcegroup" -ResourceId "/subscriptions/********/resourceGroups/********/providers/..."  -Email your.email@example.com
