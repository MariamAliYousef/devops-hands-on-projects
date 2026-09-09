# Interactive Directory Backup & Retention Tool
An interactive, production-ready Bash script designed to automate directory archives using `.tar.gz` compression while enforcing a retention policy to optimize storage space.
## Overview
Manual backups are considered to human error, inconsistent naming, and disk saturation. This tool provides a menu-driven interface to archive target directories on demand and automatically purge legacy backup files older than a specified retention threshold (7 days).
## Features
- **Interactive CLI Menu:** User-friendly navigation built using `while` loops and `case` constructs.
- **Compressed Archiving:** Generates timestamped `.tar.gz` archives using ISO-8859/ISO-8601 date formats to avoid naming collisions.
- **Automated Retention Engine:** Scans target directories and safely purges archives older than 7 days using `find -mtime`.
- **Validation Checks:** Verifies target path existence and non-empty inputs before starting the compression pipeline. 
## Requirements
- **OS:** Linux (Ubuntu/Debian, RHEL/CentOS, Rocky Linux)
- **Shell:** `bash` 4.0+
- **Utilities:** `tar`, `find`, `date`, `gzip`
## Usage Guide
**1. Navigate to the project directory:**
```bash
cd 02-directory-backup-tool/
```
**2. Set execution permissions:**
```bash
chmod +x directory_backup.sh
```
**3. Run the script:**
```bash
./directory_backup.sh
```
## Retention Logic
Retention cleanup uses `find` to isolate archives matching the retention limit (+7 days):
```bash
find /path/to/backups -type f -name "*.tar.gz" -mtime +7 -exec rm -f {} \;
```
## Sample Execution Output
```text
===============================
     Directory Backup Manager
===============================
1) Create new backup.
2) List Existing backups.
3) Clean backups older than 7 days.
4) Exit
===============================
Select an option [1-4]:
```
