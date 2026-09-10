# Service Status Monitor & Self-Healer
An automated monitoring and recovery agent built in Bash that periodically audits critical system daemons and automatically attempts to restart any crashed services.
## Overview
Temporary service failures (e.g., Nginx or Docker crashes due to resource spikes) can lead to unexpected service degradation. This tool implements an event-driven auto-healing pattern that detects crashed processes and initiates immediate recovery attempts, writing structured records to audit log files.
## Features
- **Array-Based Service Monitoring:** Bash arrays make it easy to monitor several target services at once.
- **Silent Health Probe:** Uses `systemctl is-active --quiet` to silently check daemon state.
- **Self-healing:** Initiates recovery sequences (`systemctl start`) automatically when a service failure is detected.
- **Timestamped Auditing:** Logs all outages and recovery outcomes to a dedicated log file for compliance and incident tracking.
## Requirements
- **OS:** Linux with `systemd` (Ubuntu, Debian, RHEL, CentOS)
- **Shell:** `bash` 4.0+
- **Privileges:** `root` access or `sudo` execution (required for service restarts)
- **Utilities:** `systemctl`, `date`
## Usage Guide
**1. Navigate to the project directory:**
```bash
cd 04-service-status-monitor/
```
**2. Set execution permission:**
```bash
chmod +x ./service_status_monitor.sh
```
**3. Execute with elevated privilege:**
```bash
sudo ./service_status_monitor.sh
```
## Sample Execution Output
```text===================================
       Service Status Monitor
===================================
Service [ docker ]: RUNNING (OK)
Service [ ssh ]: RUNNING (OK)
Service [ ufw ]: DOWN / INACTIVE
---> Attempting to restart 'ufw'...
---> Service [ ufw ]:  RESTARTED Successfully!
Service [ nginx ]: RUNNING (OK)
===================================
---> Completed!! Log saved in: /user/service_monitor_logs/monitor.log
```
## Sample Audit Log File
```text
[ 2025-09-08  15:24:41 ]    WARNING: Service 'ufw' was DOWN. Attempting restart..
[ 2025-09-08  15:24:41 ]    SUCCESS: Service 'ufw' was restarted successfully!
[ 2025-09-10  08:58:14 ]    WARNING: Service 'ufw' was DOWN. Attempting restart..
[ 2025-09-10  08:58:14 ]    SUCCESS: Service 'ufw' was restarted successfully!
```
