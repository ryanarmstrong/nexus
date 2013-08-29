#!/bin/bash

#
# Pretty Status Messages
#
# Provides pretty status messages to be used with the build.sh script.
#

col=$(tput cols)
# Command to set the color to SUCCESS (Green)
SETCOLOR_SUCCESS=$(tput setaf 2)
# Command to set the color to FAILED (Red)
SETCOLOR_FAILURE=$(tput setaf 1)
# Command to set the color to FAILED (Red)
SETCOLOR_NOTICE=$(tput setaf 3)
# Command to set the color back to normal
SETCOLOR_NORMAL=$(tput sgr0)

# Function to print the SUCCESS status
function print_success() {
  printf '%s%*s%s' "$SETCOLOR_SUCCESS" $col "[ok]" "$SETCOLOR_NORMAL"
}

# Function to print the FAILED status message
function print_failure() {
  printf '%s%*s%s' "$SETCOLOR_FAILURE" $col "[error]" "$SETCOLOR_NORMAL"
}

# Function to print the NOTICE status message
function print_notice() {
  printf '%s%*s%s' "$SETCOLOR_NOTICE" $col "[notice]" "$SETCOLOR_NORMAL"
}
