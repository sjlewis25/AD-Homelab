# OPNsense Firewall Setup

OPNsense was added to the lab to introduce network segmentation and firewall rules, replacing the flat network where all machines could reach each other freely.

---

## VM Configuration

| Setting | Value |
|---|---|
| Hypervisor | VirtualBox |
| OS | OPNsense (FreeBSD-based) |
| RAM | 1024 MB |
| Disk | 10 GB |
| Adapter 1 (WAN) | NAT |
| Adapter 2 (LAN) | Internal Network (intnet) |

---

## Network Design

| Interface | Role | Subnet |
|---|---|---|
| WAN (em0) | Internet-facing, NAT | DHCP from VirtualBox |
| LAN (em1) | Internal network gateway | 192.168.10.1/24 |
| IT VLAN (Tag 10) | IT department segment | 192.168.11.0/24 |
| HR VLAN (Tag 20) | HR department segment | 192.168.20.0/24 |
| Sales VLAN (Tag 30) | Sales department segment | 192.168.30.0/24 |

---

## VLAN Configuration

Three VLANs were created under **Interfaces → Devices → VLAN**, all parented to em1 (LAN):

| VLAN Tag | Description | Parent Interface |
|---|---|---|
| 10 | IT | em1 |
| 20 | HR | em1 |
| 30 | Sales | em1 |

Each VLAN was then assigned as an interface under **Interfaces → Assignments** and configured with a static IP and enabled.

---

## DHCP Configuration

DHCP was configured using Kea DHCPv4 under **Services → Kea DHCP → Kea DHCPv4**:

| VLAN | Subnet | Pool Range |
|---|---|---|
| IT | 192.168.11.0/24 | 192.168.11.100 – 192.168.11.200 |
| HR | 192.168.20.0/24 | 192.168.20.100 – 192.168.20.200 |
| Sales | 192.168.30.0/24 | 192.168.30.100 – 192.168.30.200 |

---

## Firewall Rules

Rules are configured under **Firewall → Rules** per interface. Order matters — rules are evaluated top to bottom.

**IT Interface**
| Action | Source | Destination | Description |
|---|---|---|---|
| Pass | IT network | Any | Allow IT full access |

**HR Interface**
| Action | Source | Destination | Description |
|---|---|---|---|
| Block | HR network | 192.168.11.0/24 | Block HR from IT VLAN |
| Pass | HR network | Any | Allow HR internet and DC access |

**Sales Interface**
| Action | Source | Destination | Description |
|---|---|---|---|
| Block | Sales network | 192.168.11.0/24 | Block Sales from IT VLAN |
| Pass | Sales network | Any | Allow Sales internet and DC access |

---

## Snapshots Taken

- **OPNsense - Post Install Clean** — taken immediately after initial install and wizard completion
- **OPNsense - VLANs and Firewall Rules** — taken after VLAN and firewall configuration was complete
