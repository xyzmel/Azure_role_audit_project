# Authenticate with Azure
Connect-AzAccount

# Optional: Fetch all subscriptions
Write-Host "Fetching subscriptions..."
$subscriptions = Get-AzSubscription

# Loop through each subscription
$allReports = foreach ($subscription in $subscriptions) {
    Write-Host "Processing Subscription: $($subscription.Name)"
    Set-AzContext -SubscriptionId $subscription.Id

    # Get role assignments and definitions
    $roleAssignments = Get-AzRoleAssignment
    $roleDefinitions = Get-AzRoleDefinition

    # Process role assignments
    $report = foreach ($assignment in $roleAssignments) {
        $roleDefinition = $roleDefinitions | Where-Object { $_.Id -eq $assignment.RoleDefinitionId }
        [PSCustomObject]@{
            Subscription   = $subscription.Name
            PrincipalName  = $assignment.SignInName
            RoleName       = $roleDefinition.RoleName
            Scope          = $assignment.Scope
            AllowedActions = ($roleDefinition.Actions -join ", ")
            NotActions     = ($roleDefinition.NotActions -join ", ")
            AssignedDate   = $assignment.AssignedDate
            HasWildcard    = ($roleDefinition.Actions -contains "*") -or ($roleDefinition.NotActions -contains "*")
        }
    }

    # Return report for current subscription
    $report
}

# Save combined report
$csvPath = "./AzureRoleAudit_Combined.csv"
$allReports | Export-Csv -Path $csvPath -NoTypeInformation
Write-Host "Combined role audit report saved to $csvPath"

# Summary Report
Write-Host "Generating Summary..."
$summary = $allReports | Group-Object -Property RoleName | Select-Object Name, Count
$summary | Export-Csv -Path "./AzureRoleAudit_Summary.csv" -NoTypeInformation
Write-Host "Summary report saved to AzureRoleAudit_Summary.csv"
