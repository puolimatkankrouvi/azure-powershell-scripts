[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [String]
    $ResourceGroupName,
    [Parameter(Mandatory)]
    [String]
    $ServicePlanName,
    [Parameter(Mandatory)]
    [String]
    $Name,
    [switch]$CreateServicePlan,
    [switch]$CreateResourceGroup
)

$location = "northeurope";

if ($CreateResourceGroup){
  $resourceGroupParams = @{
    Name = $ResourceGroupName
    Location = $location
  };

  New-AzResourceGroup @resourceGroupParams;
}

if ($CreateServicePlan) {
  $servicePlanParams = @{
    Name = $ServicePlanName
    ResourceGroupName = $ResourceGroupName
    Location = $location
    Tier = "Free"
    Linux = $true
  };

  New-AzAppServicePlan @servicePlanParams;
}

$appParams = @{
  ResourceGroupName = $ResourceGroupName
  AppServicePlan = $ServicePlanName
  Name = $Name
  Location = $location
};

New-AzWebApp @appParams;
