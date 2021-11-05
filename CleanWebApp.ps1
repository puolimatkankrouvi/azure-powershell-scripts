[CmdletBinding()]
param (
  [Parameter(Mandatory)]
  [String]
  $ResourceGroupName,
  [Parameter()]
  [AllowNull()]
  [String]
  $ServicePlanName, 
  [Parameter()]
  [AllowNull()]
  [String]
  $Name
)

$params = @{
  ResourceGroupName = $ResourceGroupName
};

$nameProvided = !([String]::IsNullOrEmpty($Name));
if ($nameProvided) {
  $params.Name = $Name;
  Remove-AzWebApp @params
}

$servicePlanNameProvided = !([String]::IsNullOrEmpty($ServicePlanName));
if ($servicePlanNameProvided) {
  $params.Name = $ServicePlanName;
  Remove-AzAppServicePlan @params
}
