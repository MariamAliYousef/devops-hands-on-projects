#! /usr/bin/env bash
#
# This script used for monitoring list of services, [docker, nginx, apache, ssh, ufw]
# This script must run with root / sudo permission

# ==========================
# Service Monitoring Tool
# ==========================
#
# List of services [docker, ssh, ufw, nginx]
SERVICES=("docker" "ssh" "ufw" "nginx")

# Define log directory and file name and path
LOG_DIR="$HOME/service_monitor_logs"
LOG_FILE="$LOG_DIR/monitor.log"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# check for root / sudo permission
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}ERROR: This script must run with root / sudo permission! ${NC}"
    exit 1
fi

# create the log directory
mkdir -p "$LOG_DIR"

# =====================
#    Main Functions
# =====================

# 1- log event function, write events to log file
log_event(){
    local message="$1"
    local timestamp=$(date "+%Y-%m-%d  %H:%M:%S")
    echo "[ $timestamp ]    $message" >> "$LOG_FILE"
}

# 2- check and self-heal services function
check_and_heal_service(){
    local service_name="$1"

    # check if the service installed in the system.
    if ! systemctl list-unit-files | grep -q "^${service_name}.service" ; then
        echo -e "Service ${YELLOW}'$service_name'${NC} is not installed on this system! Skipping..."
        return
    fi

    # check if the service is active now
    if systemctl is-active --quiet "$service_name" ; then
        echo -e "Service ${BLUE}[ $service_name ]${NC}: ${GREEN}RUNNING (OK)${NC}"
    else
        echo -e "Service ${BLUE}[ $service_name ]${NC}: ${RED}DOWN / INACTIVE${NC}"
	echo -e "${YELLOW}---> Attempting to restart '$service_name'...${NC}"
        
        # calling event log function
	log_event "WARNING: Service '$service_name' was DOWN. Attempting restart.."
        
	# restart service
	systemctl start "$service_name"
        
	# re-check service status after restarting the service
	if systemctl is-active --quiet "$service_name"; then
	    echo -e "---> Service ${BLUE}[ $service_name ]${NC}: ${GREEN} RESTARTED Successfully! ${NC}"
	    log_event "SUCCESS: Service '$service_name' was restarted successfully!"
	else
	    echo -e "---> Service ${BLUE}[ $service_name ]${NC}: ${RED}Failed to restart!"
	    log_event "CRITICAL: Service '$service_name' failed to restart!"
	fi
    fi
}

# ================
#    Main Menu
# ================

echo -e "${BLUE}===================================${NC}"
echo -e "${BLUE}       Service Status Monitor      ${NC}"
echo -e "${BLUE}===================================${NC}"

for SERVICE in "${SERVICES[@]}"; do
    check_and_heal_service "$SERVICE"
done

echo -e "${BLUE}===================================${NC}"
echo -e "${GREEN}---> Completed!! Log saved in: $LOG_FILE${NC}"

