#! /usr/bin/env bash

# This script includes, 3 main functions:
# create new backup, list existing backups and delete an old backup

# Default backup destination directory
DEFAULT_BACKUP_DIR="$HOME/backups"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# ============================
#   Backup System functions
# ============================

# 1- Create a new backup function
create_backup(){
    echo -e "\n${CYAN}--- Create a New Backup ---${NC}"
    read -rp "Enter the source directory you want to backup: " SOURCE_DIR
    
    # Check if the SOURCE_DIR is empty
    if [[ -z "$SOURCE_DIR" ]]; then
	echo -e "${RED}Error: please specify the source directory${NC}"
	return
    fi

    # Check if it exist
    if [[ ! -d "$SOURCE_DIR" ]]; then
	echo -e "${RED}ERROR: Source directory '$SOURCE_DIR' not exist!!${NC}"
	return
    fi
    
    # read the destination directory for backups
    read -rp "Enter the destination directory [ Default Path: ${DEFAULT_BACKUP_DIR} ]: " DEST_DIR
    DEST_DIR="${DEST_DIR:-$DEFAULT_BACKUP_DIR}"

    # prepare the backup file
    mkdir -p "$DEST_DIR"
    local timestamp=$(date +"%Y-%m-%d_%H:%M")
    local dir_name=$(basename "$SOURCE_DIR")
    local dir_filename="${dir_name}_backup_${timestamp}.tar.gz"
    local backup_full_path="${DEST_DIR}/${dir_filename}"

    echo -e "${YELLOW}--- Starting backup for: ${SOURCE_DIR}...${NC}"

    tar -czf "$backup_full_path" "$SOURCE_DIR" 2> /dev/null

    # check if the backup done successfully, and print the backup size
    if [[ $? -eq 0 ]]; then
	local file_size=$(du -h "$backup_full_path" | awk '{ print $1 }')
	echo -e "${GREEN}Backup completed successfully!!${NC}"
	echo -e "Backup File: ${GREEN}${backup_full_path}${NC}"
	echo -e "Backup Size: ${GREEN}${file_size}${NC}"
    else
	echo -e "${RED}ERROR: Backup failed!!!${NC}"
	return
    fi
}

# 2- List Existing backups function
list_backups(){
    echo -e "\n${CYAN}--- Existing Backups --- ${NC}"
    read -rp "Enter backups directory [ Default: ${DEFAULT_BACKUP_DIR} ]:  " DEST_DIR
    DEST_DIR="${DEST_DIR:-$DEFAULT_BACKUP_DIR}"

    # Check for backups in specified directory
    if [[ -d "$DEST_DIR" ]] && [[ " $(ls -A "${DEST_DIR}")" ]] ; then
        echo -e "${YELLOW}Found backups in '${DEST_DIR}': ${NC}"
	ls -lah "${DEST_DIR}"/*.tar.gz 2>/dev/null |  awk '{ print $9 , "("$5")" }'
    else
	echo -e "${RED}No backups found in ${DEST_DIR}${NC}"
    fi
}

# 3- Clean backups older than 7 days function
clean_backups(){
    echo -e "\n${CYAN}--- Clean old backups ---${NC}"
    read -rp "Enter backups directory destination [ Default: ${DEFAULT_BACKUP_DIR} ]:  " DEST_DIR
    DEST_DIR="${DEST_DIR:-$DEFAULT_BACKUP_DIR}"

    # check the destintation directory
    if [[ ! -d "$DEST_DIR" ]]; then
        echo -e "${RED}ERROR: Directory ${DEST_DIR} doesn't exist!${NC}"
	return
    fi

    # find backups older than 7 days
    local old_files=$(find "$DEST_DIR" -type f -name "*.tar.gz" -mtime +7)
    if [[ -z "$old_files" ]]; then
        echo -e "${GREEN}No backups older than 7 days were found.${NC}"
	return
    fi
    
    echo -e "${YELLOW}The following backups are older than 7 days and will be deleted: ${NC}"
    echo "${old_files}"
    echo ""

    # Confirm before deleting
    read -rp "Are you sure you want to delete these files (y/n)?  " CONFIRM
    if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
        find "$DEST_DIR" -type f -name "*.tar.gz" -mtime +7 -exec rm -f {} \;
	echo -e "${GREEN}Old backups are deleted successfully!${NC}"
    else
	echo -e "${YELLOW}Cleanup operation canceled.${NC}"
    fi
}

# ======================
#     Main Menu Loop
# ======================
while true; do
    echo -e "\n${BLUE}===============================${NC}"
    echo -e "${BLUE}     Directory Backup Manager"
    echo -e "${BLUE}===============================${NC}"
    echo "1) Create new backup."
    echo "2) List Existing backups."
    echo "3) Clean backups older than 7 days."
    echo "4) Exit"
    echo -e "${BLUE}===============================${NC}"

    read -rp "Select an option [1-4]:  " OPTION

    case "$OPTION" in
        1)
	    create_backup
	    ;;
	2)
	    list_backups
	    ;;
	3)
            clean_backups
	    ;;
        4)
	    echo -e "${GREEN}Exiting Backup Manager.${NC}"
	    exit 0
	    ;;
	*)
	    echo -e "${RED}ERROR: Invalid option!! Please enter 1, 2, 3 or 4.${NC}"
	    ;;
    esac
done

