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


