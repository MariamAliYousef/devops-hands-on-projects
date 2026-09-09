#! /usr/bin/env bash
#
# ===================================
#  Log Analyzer and Report Generator
# ===================================
# This script needs root / sudo or at least read permission for log file

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# define log file path
LOG_FILE="${1:-/var/log/syslog}"
REPORT_DIR="$HOME/log_reports"
TIMESTAMP=$(date "+%Y-%m-%d_%H:%M:%S")
REPORT_FILE="$REPORT_DIR/log_report_$TIMESTAMP.txt"

# check if the log file exists
if [[ ! -f "$LOG_FILE" ]]; then
    echo -e "${RED}ERROR: File '$LOG_FILE' does not exist or not a regular file! ${NC}"
    echo "Usage: $0 /path/to/log file"
    exit 1
fi

# check for 'r' read permission
if [[ ! -r "$LOG_FILE" ]]; then
    echo -e "${RED}ERROR: Can't read '$LOG_FILE'. Permission denied (Try running with sudo). ${NC}"
    exit 1
fi

# creating the reports directory
mkdir -p "$REPORT_DIR"

# ====================
#    Main Functions
# ====================
generate_report(){
    echo -e "${BLUE}Analyzing '$LOG_FILE'... Please wait...${NC}\n"
    # find total lines
    local TOTAL_LINES=$(wc -l < "$LOG_FILE")

    # find total CRITICAL, ERROR, WARNING count
    local CRITICAL_COUNT ERROR_COUNT WARNING_COUNT
    CRITICAL_COUNT=$(grep -i -c "critical" "$LOG_FILE")
    ERROR_COUNT=$(grep -i -c "error" "$LOG_FILE")
    WARNING_COUNT=$(grep -i -c "warning" "$LOG_FILE")
    
    local IP_REGEX='[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'
    local TOP_IPS
    TOP_IPS=$(grep -i -E "error|failed|404|500|401|403" "$LOG_FILE" | grep -o "$IP_REGEX" | sort | uniq -c | sort -nr | head -n 5)

    # Write to log file
    {
        echo "==============================================="
	echo "              Log Analysis Report              "
	echo "==============================================="
	echo "Generated on: $(date)"
	echo "Log File    : $LOG_FILE"
	echo "Total Lines : $TOTAL_LINES"
	echo "+++++++++++++++++++++++++++++++++++++++++++++++"
	echo "Summary Stats: "
	echo " - CRITICALS: $CRITICAL_COUNT"
	echo " - ERRORS   : $ERROR_COUNT"
	echo " - WARNINGS : $WARNING_COUNT"
	echo "+++++++++++++++++++++++++++++++++++++++++++++++"
	echo "TOP 5 OFFENDING IP ADDRESSES (Errors/HTTP Failures):"
	if [ -n "$TOP_IPS" ]; then
	    echo "$TOP_IPS"
	else
            echo "  No IP addresses found in error entries."
	fi
	
	echo "==============================================="

    } > "$REPORT_FILE"

    # Print Summary report on screen
    echo -e "${GREEN}Analysis Completed!! ${NC}\n"
    echo -e "${CYAN}===  QUICK SUMMARY  ===${NC}"
    echo -e "Total Lines: $TOTAL_LINES"
    echo -e "Criticals  : ${RED}$CRITICAL_COUNT${NC}"
    echo -e "Errors     : ${RED}$ERROR_COUNT${NC}"
    echo -e "Warnings   : ${YELLOW}$WARNING_COUNT${NC}"
    
    echo -e "\n${CYAN}=== TOP OFFENDING IPs ===${NC}"
    if [ -n "$TOP_IPS" ]; then
        echo -e "${RED}$TOP_IPS${NC}"
    else
        echo "No IP addresses detected in errors."
    fi

    echo -e "\nDetailed Report generated at: ${GREEN}$REPORT_FILE${NC}"
}


# ======================
#     Main unction
# ======================

generate_report

