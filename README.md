# Azure Role Audit Script

## Overview
The **Azure Role Audit Script** is a PowerShell tool for auditing role assignments across Azure subscriptions. It provides detailed insights into roles, their permissions, and assignments.

---

## Features
- **Multi-Subscription Support**: Audits all subscriptions in your Azure account.
- **Detailed Role Analysis**: Includes allowed and denied actions for each role.
- **Wildcard Permissions Alert**: Flags roles with overly permissive actions (`*`).
- **Exportable Reports**:
  - **CSV**: Comprehensive and summary reports.
  - **HTML** (optional): Interactive, user-friendly reports.
- **Filtering Options**:
  - Filter by `Principal Name`, `Role Name`, or `Scope`.

---

## Prerequisites
1. Install Azure PowerShell:
   ```powershell
   Install-Module -Name Az -AllowClobber -Scope CurrentUser
   ```
2. Authenticate with Azure:
   ```powershell
   Connect-AzAccount
   ```

---

## Usage

### Running the Script
1. Open PowerShell with administrative privileges.
2. Run the script:
   ```powershell
   .\AzureRoleAudit.ps1
   ```

### Output
- **Comprehensive Report**: `AzureRoleAudit_Combined.csv`
- **Summary Report**: `AzureRoleAudit_Summary.csv`

---

## Customization

### Filtering
Modify the script to add filters. Example:
```powershell
$roleAssignments | Where-Object { $_.RoleName -notlike "Reader" }
```

### HTML Report (Optional)
For an HTML report, integrate `ConvertTo-Html`:
```powershell
$allReports | ConvertTo-Html | Out-File "./AzureRoleAudit_Report.html"
```

---

## Example Outputs

### Comprehensive Report
| Subscription      | Principal Name   | Role Name   | Scope                  | Allowed Actions | Not Actions | Has Wildcard |
|-------------------|------------------|-------------|------------------------|-----------------|-------------|--------------|
| Contoso Sub       | admin@contoso.com| Owner       | /subscriptions/...     | *               | -           | Yes          |

### Summary Report
| Role Name   | Count |
|-------------|-------|
| Reader      | 123   |
| Contributor | 45    |

---

## Security Considerations
- Ensure the script is run by authorized users only.
- Do not hardcode sensitive credentials in the script.
- Securely store generated reports.

---

## Future Enhancements
- Integration with Azure Policy for compliance checks.
- Email notifications with summary reports.
- Scheduled execution using Task Scheduler or Azure Automation.

---

