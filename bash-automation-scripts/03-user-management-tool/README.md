# System Administration User Management Tool
A menu-driven Bash CLI tool designed for Linux System Administrators to automate user lifecycle operations, access control modifications, and resetting user's password.
## Overview
Managing user accounts manually using isolated commands (`useradd`, `usermod`, `passwd`) can lead to operational errors, such as forgetting home directory creation, leaving inactive accounts enabled or resetting the password. This tool provides an interactive interface that enforces root privilege verification prior to execution.
## Features
- **Root Privilege Enforcement:** Checks effective user ID (`EUID == 0`) before launching administrative actions.
- **User Lifecycle Operations:** Interactively creates users with home directories and offers options to remove home data upon account deletion.
- **Account Lock Control:** Safely locks/unlocks user access via `usermod -L/-U` without modifying stored credentials.
- **Identity Inspection:** Queries system databases via `id` and `getent` to display `UID`, `GID`, `group memberships`, `home path`, and `default shell`.
## Requirements
- **OS:** Linux (Ubuntu/Debian, RHEL/CentOS, Rocky Linux)
- **Shell:** `bash` 4.0+
- **Privileges:** `root` or `sudo` execution permissions
- **Utilities:** `useradd`, `userdel`, `usermod`, `passwd`, `getent`
## Usage Guide
**1. Navigate to the project folder:**
```bash
cd 03-user-management-tool/
```
**2. Set execution permission:**
```bash
chmod +x ./user_manager.sh
```
**3. Execute with elevated privilege:**
```bash
sudo ./user_manager.sh
```
## Sample Execution Output
```text
==========================
  User Management Tool
==========================
1) Add New User
2) Delete User
3) Check User State
4) Reset User Password
5) Lock / Unlock User
6) Exit
==========================
Select an option [ 1 - 6 ]:  3

===  Check User Status  ===
Enter Username to check:  test1
User 'test1' status:
===========================
User ID (UID) :  1005
Group ID (GID):  1005
Groups:          test1
Home Directory:  /home/test1
Default Shell :  /bin/sh
===========================
```
