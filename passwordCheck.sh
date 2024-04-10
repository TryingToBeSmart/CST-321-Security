#!/bin/bash

# Check if password meets the requirements
password_check(){
    passwordFailed=false
    password=$1

    # Check min length of 8 characters
    if [ ${#password} -lt 8 ]; then
        echo "Password must be at least 8 characters"
        passwordFailed=true
    fi

    # Check for 1 numeric character
    if ! [[ $password =~ [0-9] ]]; then
        echo "Password must contain at least 1 number"
        passwordFailed=true
    fi

    # Check for non-alphabetic character: @, #, $, %, *, +, =, or !
    if ! [[ $password =~ [@#$%*+=!] ]]; then
        echo "Password must contain at least 1 special character (@, #, $, %, *, +, =, or !)"
        passwordFailed=true
    fi

    if $passwordFailed; then
        # Weak password
        echo "Weak Password!"

    else 
        # Strong password
        echo "Strong Password!"
    fi
}

# Main
if [ $# -ne 1 ]; then
    echo "Enter password"
    exit 1
fi

password_check "$1"