[CmdletBinding()]
param(
    [parameter(Mandatory)]
    [String]
    $ResourceGroupName,
    [parameter(Mandatory)]
    [String]
    $Email,
    [parameter(Mandatory)]
    [String]
    $ResourceId
)

# First test resource group and resource exist
Get-AzResourceGroup -ResourceGroupName $ResourceGroupName -ErrorAction Break;
$resource = Get-AzResource -Id $ResourceId -ErrorAction Break;

$actionGroupName = "notify-email";
$actionGroup = Get-AzActionGroup -ResourceGroupName $ResourceGroupName -Name $actionGroupName -ErrorAction SilentlyContinue;

$actionGroupDoesNotExist = $null -eq $actionGroup;
if ($actionGroupDoesNotExist)
{
    # Create action group that notifies the alerts by email.
    $emailActionGroupReceiver = New-AzActionGroupReceiver `
                                -Name "email-receiver" `
                                -EmailReceiver `
                                -EmailAddress $Email;
    $actionGroup = Set-AzActionGroup `
                    -Name $actionGroupName `
                    -ShortName "ActionGroup1" `
                    -ResourceGroupName  $ResourceGroupName `
                    -Receiver $emailActionGroupReceiver;
}

$alertRuleName = "cpu-metric";

$alertRule = Get-AzMetricAlertRuleV2 -ResourceGroupName $ResourceGroupName -Name $alertRuleName -ErrorAction SilentlyContinue;

$alertRuleDoesNotExist = $null -eq $alertRule;

if ($alertRuleDoesNotExist)
{
    # Alert condition for CPU rising over 5%.
    $condition = New-AzMetricAlertRuleV2Criteria -MetricName "Percentage CPU" -TimeAggregation Average -Operator GreaterThan -Threshold 5;
    
    # Add-AzMetricAlertRuleV2 requires the action group as inmemory object.
    $actionGroupWithId = New-AzActionGroup -ActionGroupId $actionGroup.Id;

    Write-Host $resource.ResourceId;

    Add-AzMetricAlertRuleV2 `
        -Name $alertRuleName `
        -ResourceGroupName $ResourceGroupName `
        -TargetResourceId $resource.ResourceId `
        -Condition $condition `
        -ActionGroup $actionGroupWithId `
        -WindowSize (New-TimeSpan -Minutes 5) `
        -Frequency  (New-TimeSpan -Minutes 5) `
        -Severity 3
}
    