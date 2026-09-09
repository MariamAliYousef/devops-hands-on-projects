#! /usr/bin/env bash

# ==============================
#     User Management Tool
# ==============================

# This script is used to add, delete, check and reset passwords for users
# This script needs root/sudo permission to run successfully!
#
# Color Codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Check for root / sudo permission
if [[ "$EUID" -ne 0 ]]; then
    echo -e "${RED}ERROR: This script needs root / sudo permission to run!!${NC}"
    exit 1
fi    

# ============================
#       Main Functions
# ============================

# 1- Add New User function
create_user(){
    echo -e "\n${CYAN}=== Create New User ===${NC}"
    read -rp "Enter Username:  " USERNAME
    # check the input isn't empty
    if [[ -z "$USERNAME" ]]; then
        echo -e "${RED}ERROR: Username can't be empty!!${NC}"
	return
    fi

    # check if the user already exists!
    if id "$USERNAME" &> /dev/null ; then
	echo -e "${YELLOW}User '$USERNAME' already exists..${NC}"
        return
    fi

    # Creating the new user with home directory
    useradd -m "$USERNAME"

    # confirm if its completed successfully
    if [[ $? -eq 0 ]]; then
	echo -e "${GREEN}User '$USERNAME' created successfully! ${NC}"
	read -rp "Do you want to set a password now (y/n)? " SET_PASS

	if [[ "$SET_PASS" =~ ^[Yy]$ ]]; then
	    passwd "$USERNAME"
	fi
    else
        echo -e "${RED}ERROR: Failed to create user: '$USERNAME'${NC}"
    fi
}

# 2- Delete User function
delete_user(){
    echo -e "\n${CYAN}===  Delete User  ===${NC}"
    read -rp "Enter Username to delete:  " USERNAME

    # check for input not empty
    if [[ -z "$USERNAME" ]]; then
	echo -e "${RED}ERROR: Username can't be empty!${NC}"
	return
    fi
    
    # check if the user exist
    if ! id "$USERNAME" &> /dev/null; then
	echo -e "${RED}ERROR: User '$USERNAME' doesn't exists! ${NC}"
	return
    fi

    # check for deleting user's home directory as well
    read -rp "Do you want to remove the home directory as well (y/n)?  " DEL_HOME
    if [[ "$DEL_HOME" =~ ^[Yy]$ ]]; then
        userdel -r "$USERNAME"
    else
	userdel "$USERNAME"
    fi

    # check for success
    if [[ $? -eq 0 ]]; then
	echo -e "${GREEN}User '$USERNAME' deleted successfully! ${NC}"
    else
	echo -e "${RED}ERROR: Failed to delete user '$USERNAME' ${NC}"
    fi
}

# 3- Check User State function
check_user(){
    echo -e "\n${CYAN}===  Check User Status  ===${NC}"
    read -rp "Enter Username to check:  " USERNAME

    # check for empty
    if [[ -z "$USERNAME" ]]; then
	echo -e "${RED}ERROR: Username can't be empty!${NC}"
	return
    fi

    # check for user status
    if id "$USERNAME" &> /dev/null ; then
	echo -e "${GREEN}User '$USERNAME' status:  ${NC}"
	echo "==========================="
	echo "User ID (UID) :  $(id -u "$USERNAME")"
	echo "Group ID (GID):  $(id -g "$USERNAME")"
	echo "Groups:          $(id -nG "$USERNAME")"
	echo "Home Directory:  $(getent passwd "$USERNAME" | cut -d: -f6)"
	echo "Default Shell:   $(getent passwd "$USERNAME" | cut -d: -f7)"
	echo "==========================="
    else
	echo -e "${RED}ERROR: User '$USERNAME' doesn't exist! ${NC}"
    fi
}

# 4- Reset User's Password function
reset_password(){
    echo -e "\n${CYAN}===  Reset Password  ===${NC}"
    read -rp "Enter Username:  " USERNAME

    # check user exists
    if ! id "$USERNAME" &> /dev/null ; then
	echo -e "${RED}ERROR: User '$USERNAME' doesn't exist! ${NC}"
	return
    fi
    passwd "$USERNAME"
}

# 5- Lock / Unlock User account function
lock_unlock_user(){
    echo -e "\n${CYAN}===  Lock / Unlock User  ===${NC}"
    read -rp "Enter Username:  " USERNAME

    # validate the input
    if [[ -z "$USERNAME" ]]; then
	echo -e "${RED}ERROR: Username can't be empty!${NC}"
	return
    fi

    # check user status
    if ! id "$USERNAME" &> /dev/null ; then
        echo -e "${RED}ERROR: User '$USERNAME' doesn't exists! ${NC}"
	return
    fi

    # Get lock / unlock status
    local pass_status=$(passwd -S "$USERNAME" 2> /dev/null  | awk '{ print $2 }' )
    
    # Check for lock status
    if [[ "$pass_status" == "L" ]]; then
	echo -e "Current State: Account is ${RED}Locked!${NC}"
    else
	echo -e "Current State: Account is ${GREEN} Active / Unlocked! ${NC}"
    fi

    # Change account status
    read -rp "Do you want to  change the current state (y / n)? " OPTION
    if [[ "$OPTION" =~ ^[Yy]$ ]]; then
	echo "Select Action: "
	echo "1) Lock Account"
	echo "2) Unlock Account"
	read -rp "Enter [ 1 - 2 ]: " CHOISE
	
	case "$CHOISE" in
	    1)
                usermod -L "$USERNAME"
		if [[ $? -eq 0 ]]; then
		    echo -e "${GREEN}Account '$USERNAME' has been LOCKED successfully! ${NC}"
		else
		    echo -e "${RED}ERROR: Failed to lock account '$USERNAME' ${NC}"
		fi
		;;
	    2)
		usermod -U "$USERNAME"
		if [[ $? -eq 0 ]]; then
		    echo -e "${GREEN}Account '$USERNAME' has been NULOCKED successfully! ${NC}"
		else
		    echo -e "${RED}ERROR: Failed to UNLOCK Account '$USERNAME'${NC}"
		fi
		;;
	    *)
		echo -e "${YELLOW}Invalid option, returning to main menu! ${NC}"
		;;
	esac
    fi
}

# ---- Main Menu ----
while true; do
    echo -e "\n${BLUE}==========================${NC}"
    echo -e "${BLUE}  User Management Tool   ${NC}"
    echo -e "${BLUE}==========================  ${NC}"
    echo "1) Add New User"
    echo "2) Delete User"
    echo "3) Check User State"
    echo "4) Reset User Password"
    echo "5) Lock / Unlock User"
    echo "6) Exit"
    echo -e "${BLUE}==========================  ${NC}"
    read -rp "Select an option [ 1 - 6 ]:  " OPTION

    case "$OPTION" in
        1)
	    create_user
	    ;;
	2)
            delete_user
	    ;;
	3)
	    check_user
	    ;;
	4)
	    reset_password
	    ;;
	5)
	    lock_unlock_user
	    ;;
	6)
	    echo -e "${GREEN}Exiting the User Management Tool..${NC}"
	    exit 0
	    ;;
	*)
	    echo -e "${RED}ERROR: Invalid option, please enter 1, 2, 3, 4, 5 or 6.${NC}"
	    ;;
    esac
done    
