# Log Analyzer Tool
Bash script designed to analyze web server and system logs, aggregate error metrics, and isolate suspicious client IP addresses.
## Overview
Parsing large log files (`syslog`, Nginx/Apache `access.log`) manually during incident response or security audits is inefficient. This tool automates log analysis by parsing HTTP status codes, calculating failure rates, and extracting top offending client IPs.
## Features
- **High-Speed Text Processing:** Utilizes `grep`, `awk`, `uniq`, and `sort` pipelines for quick parsing of multi-megabyte log files.
- **Regex IP Extraction:** Extended Regular Expressions (`grep -E`) to extract IPv4 pattern matches associated with client errors (`4xx`) and server errors (`5xx`).
- **Flexible Argument Parsing:** Accepts custom log paths passed via command-line arguments (`$1`) or analyze system logs, defaults (`/var/log/syslog`).
- **Automated Summary Reporting:** Generates timestamped diagnostic summaries saved directly to a designated reports directory. 
## Requirements
- **OS:** Linux / Unix-like environment
- **Shell:** `bash` 4.0+
- **Utilities:** `grep`, `awk`, `sort`, `uniq`, `head`, `wc`
## Usage Guide
**1. Navigate to the project directory:**
```bash
cd 05-log-analyzer/
```
**2. Set execution permission:**
```bash
chmod +x log_analyzer.sh
```
**3. Run using default system logs (/var/log/syslog):**
```bash
./log_analyzer.sh
```
**4. Run using custom log file:**
```bash
./log_analyzer.sh /var/log/nginx/access.log
```
## Sample Output
```text
Analyzing '/var/log/syslog'... Please wait...

Analysis Completed!!

===  QUICK SUMMARY  ===
Total Lines: 13335
Criticals  : 0
Errors     : 249
Warnings   : 46

=== TOP OFFENDING IPs ===
No IP addresses detected in errors.

Detailed Report generated at: /home/user/log_reports/log_report_2025-09-10_09:19:45.txt
```
## Sample Audit Log File
```text
===============================================
              Log Analysis Report
===============================================
Generated on: Thu Sep 10 09:19:46 AM UTC 2026
Log File    : /var/log/auth.log
Total Lines : 13335
+++++++++++++++++++++++++++++++++++++++++++++++
Summary Stats:
 - CRITICALS: 0
 - ERRORS   : 249
 - WARNINGS : 46
+++++++++++++++++++++++++++++++++++++++++++++++
TOP 5 OFFENDING IP ADDRESSES (Errors/HTTP Failures):
  2 192.168.x.x
===============================================
```
