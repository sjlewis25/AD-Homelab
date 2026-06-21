# Configuration Details

## Domain Controller (DC01)

- OS: Windows Server 2022 Standard (Evaluation), Desktop Experience
- Roles installed: Active Directory Domain Services, DNS, DHCP
- Domain: corp.local (new forest, Server 2016 functional level)
- Static IP addressing on the internal network, with DNS pointed at itself

## Client Machine (CLIENT1)

- OS: Windows Server 2022 Standard (Evaluation)
- Joined to corp.local as a domain member
- Static IP addressing on the same internal network as DC01, with DNS pointed at DC01

Both machines communicate over a VirtualBox internal network, isolated from the host network.

## Active Directory Structure

**Organizational Units**
- IT
- HR
- Sales

**Users**
- A user account was created in each OU to represent a department employee, with naming and login matching standard first-initial-last-name convention
- Password reset and account disable/enable were both tested and confirmed working

**Security Groups**
- One security group per department (HR, IT, Sales), used as the access control mechanism for file shares rather than applying permissions directly to OUs

## Group Policy

A domain-wide Group Policy Object enforces account lockout policy:
- Lockout threshold: 5 invalid login attempts
- Lockout duration: 30 minutes
- Reset counter after: 30 minutes

The policy is linked at the domain level so it applies to all users and computers in corp.local. Applied policy was confirmed using gpupdate /force and gpresult /r on the client machine.

## DHCP

A DHCP scope was configured to hand out addresses automatically to machines joining the network:
- Scope covers a defined range on the internal network
- Default gateway and DNS server (DC01) handed out automatically
- 8-day lease duration
- Scope activated and verified through the DHCP console

## File Shares

Three department shares were created, one each for HR, IT, and Sales:
- Default "Everyone" permission removed
- Share permissions set to Full Control for the matching department security group only
- NTFS permissions set to Modify for the matching department security group only

This ensures each department can only access its own share, not the others.

## Verification Performed

- Logged into the client machine as a domain user from the IT OU and completed the mandatory first-login password change
- Ran gpresult /r on the client to confirm the user's OU placement, applied Group Policy, and group memberships
- Browsed to the DC01 shares from the client machine as the domain user and confirmed access to the correct department folders
- Used Event Viewer on DC01 to locate a failed logon attempt (Event ID 4625) generated during testing, alongside normal logon/logoff events (4624, 4634, 4672)

## PowerShell Automation

A PowerShell-based approach was used to provision new AD users in bulk rather than creating them one at a time through the GUI. Each new user is created with:
- Account placed in the correct OU based on department
- Membership added to the matching department security group
- A temporary password with a forced password change at next logon, matching standard new-hire provisioning practice
