# Bulk-provisions new Active Directory users from a predefined list.
# Each user is created in the correct OU, added to the matching department
# security group, and assigned a temporary password that must be changed
# at next logon.
#
# Usage: Pass the temporary password as a parameter rather than hardcoding it.
# Example: .\New-BulkUsers.ps1 -TempPassword (Read-Host -AsSecureString "Temp password")

param(
    [Parameter(Mandatory=$true)]
    [SecureString]$TempPassword
)

$newUsers = @(
    @{Name="Mike Johnson"; Sam="mjohnson"; OU="IT"},
    @{Name="Sarah Williams"; Sam="swilliams"; OU="HR"},
    @{Name="Tom Garcia"; Sam="tgarcia"; OU="Sales"}
)

$domain = "corp.local"
$tempPassword = $TempPassword

foreach ($u in $newUsers) {
    New-ADUser `
        -Name $u.Name `
        -SamAccountName $u.Sam `
        -UserPrincipalName "$($u.Sam)@$domain" `
        -Path "OU=$($u.OU),DC=corp,DC=local" `
        -AccountPassword $tempPassword `
        -ChangePasswordAtLogon $true `
        -Enabled $true

    Add-ADGroupMember -Identity $u.OU -Members $u.Sam

    Write-Host "Created $($u.Name) in $($u.OU) and added to $($u.OU) group" -ForegroundColor Green
}

Write-Host "`nDone. $($newUsers.Count) user(s) processed." -ForegroundColor Cyan