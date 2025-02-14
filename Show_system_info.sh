#!/bin/bash

# Function to print system information
print_system_info() {
    echo "----- System Information -----"
    
    # Hostname
    echo "Hostname: $(hostname)"
    
    # Operating System
    echo "Operating System: $(uname -s)"
    
    # OS Version
    echo "OS Version: $(uname -r)"
    
    # Architecture
    echo "Architecture: $(uname -m)"
    
    # CPU Info
    echo "CPU Info: $(lscpu | grep 'Model name' | cut -d ':' -f2)"
    
    # Memory Info
    echo "Total Memory: $(free -h | grep Mem | awk '{print $2}')"
    
    # Available Memory
    echo "Available Memory: $(free -h | grep Mem | awk '{print $7}')"
    
    # Disk Usage
    echo "Disk Usage: $(df -h | grep '^/dev' | awk '{print $1, $2, $3, $4, $5}')"
    
    # Uptime
    echo "Uptime: $(uptime -p)"
    
    # Network Info
    echo "Network Interfaces:"
    ifconfig -a | grep -E '(^[a-zA-Z0-9]+|inet )' | sed -e 's/inet/   inet/g' -e 's/lo//g' -e 's/   inet6/inet6/g'
    
    # Kernel Version
    echo "Kernel Version: $(uname -v)"
    
    # Number of Processes
    echo "Number of Processes: $(ps aux | wc -l)"
    
    # Current User
    echo "Current User: $(whoami)"
    
    echo "----- End of Information -----"
}

# Run the function
print_system_info
