# Active Directory Home Lab

A self-built two-machine Active Directory environment created in VirtualBox to practice real-world Windows Server administration, help desk, and identity management tasks. This lab simulates a small business network and was built from the ground up, including recovering from a full domain controller failure along the way.

## Overview

This lab runs a domain controller and a domain-joined client machine inside an isolated internal network. It includes a working Active Directory domain, organizational units, user and group management, Group Policy, DHCP, file shares with proper permissions, and PowerShell automation for user provisioning.

## Lab Topology

| Machine | Role | OS |
|---|---|---|
| DC01 | Domain Controller, DNS, DHCP | Windows Server 2022 Standard (Evaluation) |
| CLIENT1 | Domain-joined member server | Windows Server 2022 Standard (Evaluation) |

Both machines run in VirtualBox on an isolated internal network so they can communicate with each other without touching the host network.

Domain name: **corp.local**

## What's Built

**Active Directory Structure**
- Organizational Units for IT, HR, and Sales
- User accounts provisioned into the correct OU per department
- Security groups matching each OU, used for file share permissions
- A domain-wide Group Policy enforcing account lockout after 5 failed login attempts

**Networking**
- DHCP scope handing out addresses to client machines on the network
- DNS integrated with Active Directory on the domain controller
- OPNsense firewall with VLAN segmentation isolating IT, HR, and Sales departments
- Firewall rules preventing cross-department access while allowing all VLANs to reach the domain controller

**File Shares**
- Department shares (HR, IT, Sales) with share and NTFS permissions locked down to the matching security group, replacing the default "Everyone" access

**Automation**
- A PowerShell script for bulk-provisioning new AD users from a simple list, instead of creating accounts manually one at a time

**Verification**
- Confirmed end-to-end domain login from the client machine as a domain user
- Verified Group Policy was correctly applied using gpresult
- Verified department file share access worked correctly for a domain user
- Used Event Viewer to review failed login attempts (Event ID 4625) as part of basic security monitoring

## Documentation

- [Configuration Details](docs/configurations.md) — full settings for both machines, AD structure, DHCP, shares, and GPOs
- [OPNsense Firewall Setup](docs/opnsense-setup.md) — VLAN design, firewall rules, and DHCP configuration
- [Troubleshooting Log](docs/troubleshooting-log.md) — real issues encountered during the build and how each was resolved

## Skills Demonstrated

Windows Server 2022 administration, Active Directory Domain Services, Group Policy Management, DNS/DHCP configuration, NTFS and share permissions, PowerShell scripting and automation, VirtualBox virtualization, OPNsense firewall configuration, VLAN design and segmentation, systematic troubleshooting and root cause documentation.

## What's Next

Planned next phase of this lab includes centralized log monitoring with a SIEM tool (Wazuh) and basic vulnerability scanning practice using Kali Linux.
