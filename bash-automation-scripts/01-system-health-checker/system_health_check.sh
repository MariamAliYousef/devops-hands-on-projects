#! /usr/bin/env bash
# ================ System Health Check ==================

# 1-Define Threshold values
CPU_THRESHOLD=80
RAM_THRESHOLD=80
DISK_THRESHOLD=80

# Creating log directory and file
LOG_DIR="$HOME/scripting_labs/logs"
mkdir -p "${LOG_DIR}"
LOG_FILE="${LOG_DIR}/health.log"

# 2- Color Codes
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ============================
#     Function Definitions
# ============================

# 1- CPU Usage check function
cpu_check() {
	local cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{ print $2 }' | cut -d'.' -f1)
    # check if cpu usage greater than threshold
    if [[ "$cpu_usage" -gt "$CPU_THRESHOLD" ]]; then
        echo -e "CPU Usage:  ${RED}${cpu_usage}% (High Usage)${NC}"
    else
	    echo -e "CPU Usage: ${GREEN}${cpu_usage}% (OK)${NC}"
    fi 
}

# 2- Memeory Usage
memory_check() {
	local mem_usage=$(free -m | awk 'NR==2 {printf "%.0f", $3*100/$2 } ')
	if [[ "$mem_usage" -gt "$RAM_THRESHOLD" ]]; then
		echo -e "RAM Usage: ${RED}${mem_usage}% (High Usage!)${NC}"
	else
		echo -e "RAM Usage: ${GREEN}${mem_usage}% (OK)${NC}"
	fi
}

# 3- Disk check
disk_check() {
	local disk_usage=$(df -h / | awk 'NR==2 { print $5 } ' | sed 's/%//')
	if [[ "$disk_usage" -gt "$DISK_THRESHOLD" ]]; then
		echo -e "Disk Usage: ${RED}${disk_usage}% (High Usage!)${NC}"
	else
		echo -e "Disk Usage: ${GREEN}${disk_usage}% (OK)${NC}"
	fi
}

# 4- Full Report
show_report() {
	echo -e "${BLUE}=============================${NC}"
	echo -e "${BLUE}     System Health Check     ${NC}"
	echo -e "${BLUE}=============================${NC}"
	cpu_check
	memory_check
	disk_check
}

# 5- show help function
show_help(){
	echo "Usage: $0 [OPTION]"
	echo "OPTIONS: "
	echo "--all, -a		Run all system health check (Default)"
	echo "--cpu		Check for CPU Usage"
	echo "--ram		Check for RAM Usage"
	echo "--disk		Check for Disk Usage"
	echo "--log, -l		Save to Log File"
	echo "--help, -h	Show this help menu"

}

# 6- Save to file
save_to_file() {
	local timestamp=$(date +"%Y-%m-%d")
	echo "================= Timestamp: ${timestamp} ==================="
	cpu_check
	memory_check
	disk_check
} >> "${LOG_FILE}"

# Main Execution
OPTION="${1:---all}"

case "$OPTION" in
	--all|-a)
		show_report
		;;
	--cpu)
		cpu_check
		;;
	--ram)
		memory_check
		;;
	--disk)
		disk_check
		;;
	--help|-h)
		show_help
		;;
	--log|-l)
		echo -e "${BLUE}Saving Logs to: ${LOG_FILE}${NC}"
		save_to_file
		echo -e "${GREEN}Logs saved successfully!!${NC}"
		;;
	*)
		echo "${RED}Invalid Option: ${OPTION}${NC}"
		show_help
		exit 1
		;;
esac
