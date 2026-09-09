# System Health Checker & Cron Logger
A production-ready Bash script designed to monitor critical Linux system resources [ CPU load, Memory usage, and Disk consumption ] and issue timestamped warnings when thresholds are breached.

## Overview
System administrators need simple, reliable resource tracking without the overhead of heavy monitoring agent installations. This script automates resource auditing, evaluates safety limits (80% utilization threshold), and routes structured logs to log file.

## Features
- **Metric Extraction:** Gathers real-time CPU utilization `%`, RAM usage `%`, and Disk space `%` for root partition (`/`).
- **Threshold Alerts:** Identifies utilization spikes above defined safety limits (80%).
- **Structured Log Output:** Formats records with standard ISO-like timestamps and logging levels.
- **Cron Automation Ready:** Built using absolute binary paths to ensure error-free execution under background scheduler contexts (`cron`).

## Requirements
- **OS:** Linux (Ubuntu/Debian, RHEL/CentOS, Rocky Linux)
- **Shell:** `bash` 4.0+
- **Utilities:** `top`, `df`, `free`, `awk`, `grep`, `cut`

## Usage Guide
**1. Navigate to project folder**
```bash
cd 01-system-health-checker/
```
**2. Set execution permission:**
```bash
chmod +x system_health_check.sh
```
**3. Run Manually:**
```bash0 * * * * /bin/bash /path/to/system_health_check.sh >> /path/to/health.log 2>&1
./system-health-check.sh
```
## Automated Scheduling via `cronjob`
To schedule an automated system health check every hour at minute 0 and direct logs to a dedicated log file:
**1. Open the crontab editor:**
```bash
crontab -e
```
**2. Append the following entry (replace `/path/to` with your actual directory absolute path):**
```text
0 * * * * /bin/bash /path/to/system_health_check.sh >> /path/to/health.log 2>&1
```
## Sample Log Output (`health.log`)
```text
================= Timestamp: 2026-09-07 ===================
CPU Usage: 4% (OK)
RAM Usage: 34% (OK)
Disk Usage: 36% (OK)
```
