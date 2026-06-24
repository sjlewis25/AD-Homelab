# Troubleshooting Log

Real issues encountered while building this lab, documented the way a help desk ticket or incident report would be written.

---

## Incident 1: Domain Controller Boot Loop

**Symptom**
After an improper shutdown, DC01 failed to boot and entered a repeating BAD_SYSTEM_CONFIG_INFO error loop.

**Root Cause**
The improper shutdown corrupted the SYSTEM registry hive, which Windows needs to boot correctly.

**Resolution Attempted**
Several built-in Windows recovery options were attempted, including restoring the registry hive from Windows Recovery Environment and rebuilding the boot configuration data. The underlying Windows installation was too corrupted to recover cleanly through these methods.

**Final Resolution**
The corrupted virtual disk was removed and a clean installation of Windows Server 2022 was performed. A snapshot was taken immediately after the fresh install to protect against future loss.

**Lesson Learned**
Always shut down virtual machines properly, and take a snapshot immediately after any major milestone (fresh install, role installation, domain promotion) so a bad shutdown never costs more than the most recent snapshot.

---

## Incident 2: Disk Space Exhaustion During Reinstall

**Symptom**
A disk full error occurred partway through reinstalling Windows Server.

**Root Cause**
Leftover virtual disk files from the previous corrupted installation, including an old snapshot disk, were still consuming space on the host drive.

**Resolution**
The unused virtual disk and snapshot files were identified and deleted, freeing enough space for the installation to complete successfully.

**Lesson Learned**
Virtual disk files and snapshots need to be actively managed and cleaned up, especially when working with limited host storage. Old files left behind from a failed build can silently eat into space needed for the next attempt.

---

## Incident 3: Client Machine Domain Join Failure

**Symptom**
A client virtual machine could not be joined to the corp.local domain. Attempts returned an error indicating the machine could not be unjoined from a previous domain it was already a member of.

**Root Cause**
The client machine had previously been joined to a different, now-defunct domain. Its machine account record was still referencing that old domain, which no longer existed and could not be contacted to properly release the machine account.

**Resolution Attempted**
Several methods were tried to force the machine to release its old domain membership, including forced unjoin commands and manual registry edits. None succeeded, since the original domain no longer existed and the reference could not be cleanly resolved.

**Final Resolution**
The original virtual machine was retired and a brand new virtual machine was built from scratch. The new machine joined corp.local successfully on the first attempt, since it had no prior domain history.

**Lesson Learned**
When a machine has a conflicting or orphaned domain membership that can't be resolved through standard unjoin methods, rebuilding the machine is often faster and more reliable than continuing to troubleshoot a broken machine account reference.

---

## Incident 4: OPNsense LAN Interface Not Detected

**Symptom**
After installing OPNsense in VirtualBox with two network adapters, only one interface (em0) was detected during interface assignment. The second adapter (em1) showed no link and could not be assigned as LAN.

**Root Cause**
VirtualBox's Internal Network adapter type did not initialize a link for the second adapter during the OPNsense install and first boot. OPNsense reported no link up on em1.

**Resolution Attempted**
Verified adapter settings in VirtualBox — adapter type and cable connected were both correct. Changing adapter settings with the VM powered off did not resolve the issue.

**Final Resolution**
Temporarily changed Adapter 2 from Internal Network to Host-only Adapter. This allowed OPNsense to detect em1 and complete interface assignment. After the web GUI was configured and accessible, Adapter 2 was switched back to Internal Network and em1 was manually typed during interface assignment to restore the correct lab topology.

**Lesson Learned**
VirtualBox Internal Network adapters can fail to present a link during OPNsense setup. Using Host-only temporarily to get through initial configuration, then switching back, is a reliable workaround.

---

## Incident 5: CLIENT1 on Wrong Subnet After OPNsense Install

**Symptom**
After OPNsense was configured with a LAN IP of 192.168.10.1, CLIENT1 could not reach the OPNsense web GUI.

**Root Cause**
CLIENT1 had a static IP of 192.168.1.50 from the previous flat network configuration, which is a different subnet than the OPNsense LAN (192.168.10.0/24).

**Resolution**
Updated CLIENT1's static IP configuration to 192.168.10.50/24 with a default gateway of 192.168.10.1 and DNS pointing to DC01 at 192.168.10.10. CLIENT1 was then able to reach the OPNsense web GUI successfully.

**Lesson Learned**
When introducing a firewall or router to an existing lab, all existing machines need their IP configuration reviewed to ensure they match the new subnet design.

---

## Incident 6: VLAN IP Conflict with Existing LAN Interface

**Symptom**
When configuring the IT VLAN interface with IP 192.168.10.1, OPNsense returned an error stating the IP was already in use by another interface.

**Root Cause**
The LAN interface (em1) was already assigned 192.168.10.1/24. Assigning the same IP to the IT VLAN interface caused a conflict.

**Resolution**
Changed the IT VLAN subnet to 192.168.11.0/24 with a gateway of 192.168.11.1, keeping HR on 192.168.20.0/24 and Sales on 192.168.30.0/24. The existing LAN interface retained 192.168.10.0/24 for DC01 and domain infrastructure.

**Lesson Learned**
Each interface in OPNsense must be on a unique subnet. Plan IP addressing before configuration to avoid conflicts, especially when VLANs are being layered on top of an existing LAN interface.


