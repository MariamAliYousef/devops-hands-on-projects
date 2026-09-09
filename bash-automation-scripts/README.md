# Bash Automation Toolkit
A collection of 5 production-ready Bash scripts created to solve core Linux System administration, automated backup, infrastructure monitoring, and log parsing following best practices. 
## Repository Structure

```text
bash-automation-scripts/
├── 01-system-health-checker/       # System resources monitoring & Cron automation
├── 02-directory-backup-tool/       # Compressed backups & retention policy engine
├── 03-user-management-tool/        # Admin user lifecycle & control CLI
├── 04-service-status-monitor/      # Service health auditor & self-healing recovery
└── 05-log-analyzer/                # Log analyzer, Regex IP extractor & reporter
```
## Projects Overview
| # | Project Name | Key Concepts & Tool Used | Technical Documentation |
| :--- | :--- | :--- | :--- |
| **01** | **System Health Checker** | `top`, `free`, `df`, Threshold Logic, CronJob | [View README](./01-system-health-checker) |
| **02** | **Directory Backup Tool** | `tar`, `find -mtime` retention, Interactive `case` Menu | [View README](./02-directory-backup-tool) |
| **03** | **User Management Tool** | `useradd`, `userdel`, `usermod -L/U` lock state, `EUID` Validation | [View README](./03-user-management-tool) |
| **04** | **Service Status Monitor** | `systemctl` status monitoring, Arrays, Self-healing logic | [View README](./04-service-status-monitor) |
| **05** | **Log Analyzer** | Text Processing (`grep`, `awk`, `uniq`, `sort`), IP Regex | [View README](./05-log-analyzer) |

# Quick Start Guide
### 1- Clone the repository and navigate to the scripts directory
```text
git clone [https://github.com/MariamAliYousef/devops-hands-on-projects.git](https://github.com/MariamAliYousef/devops-hands-on-projects.git)
cd devops-hands-on-projects.git/bash-automation-scripts
```
### 2- Make all scripts executable in one step:
```text
chmod +x */*.sh
```
### 3- Navigate to any individual project directory to view detailed usage guidelines and execute the tool.



