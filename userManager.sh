#!/bin/bash

# Bash script to manage users. Takes 3 args: 
# an input filename of users, a group name, and an operation flag.
# The input will be a text file with a list of
# users to add to or remove from the system.
# Each line contains a user ID and encrypted password separated
# by a space character.  The passwords will be encrypted
# using openssl with the command line.

# Check the number of arguments
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <filename> <group_name> <operation_flag> (-a to add and -r to remove)"
    exit 1
fi

input_file="$1"
group_name="$2"
operation_flag="$3"

# Check if group exists but don't print to console using >/dev/null
if ! getent group "$group_name" >/dev/null; then
    echo "Group $group_name does not exist. Creating..."
    groupadd "$group_name"
fi

# Check if the operation_flag is valid: -a to add or -r to remove
if [ "$operation_flag" != "-a" ] && [ "$operation_flag" != "-r" ]; then
    echo "Correct operation flags are -a to add users or -r to remove users"
    exit 1
fi

# Function to add users
# cyberciti.biz/faq/unix-howto-read-line-by-line-from-file/
add_users() {
    while read -r line; do 
        if [ -n "$line" ]; then
            user_id=$(echo "$line" | cut -d ' ' -f 1)
            password=$(echo "$line" | cut -d ' ' -f 2)
            useradd -m -g "$group_name" -p "$password" "$user_id"
            echo "User added: $user_id"
        fi
    done < "$input_file"
}

# Function to remove users
remove_users() {
    while read -r line; do
        if [ -n "$line" ]; then
            user_id=$(echo "$line" | cut -d ' ' -f 1)
            userdel -r "$user_id"
            echo "User removed: $user_id"
        fi
    done < "$input_file"
}

# Call the correct function based on operation_flag
if [ "$operation_flag" == "-a" ]; then
    add_users
elif [ "$operataion_flag" == "-r" ]; then
    remove_users
fi