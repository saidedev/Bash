#!/bin/bash

# Define color codes
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
CYAN="\e[36m"
RESET="\e[0m"

# Ensure the script runs as root
if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}[!] This script requires root privileges.${RESET}"
    exec sudo bash "$0"
fi

# Prompt user for target IP
echo -e "${CYAN}Enter target IP or domain:${RESET} "
read TARGET

# Validate input
if [[ -z "$TARGET" ]]; then
    echo -e "${RED}[!] No target specified. Exiting...${RESET}"
    exit 1
fi

# Generate output filename
OUTPUT="nmap_scan_$(date +%F_%H-%M-%S).txt"

# Display scan start message
echo -e "${YELLOW}[+] Running advanced Nmap scan on ${BLUE}$TARGET${RESET}..."
echo -e "${YELLOW}[+] Results will be saved in ${GREEN}$OUTPUT${RESET}"

# Determine best scan type (SYN scan preferred, TCP fallback)
echo -e "${CYAN}[*] Checking if SYN scan (-sS) is supported...${RESET}"
if nmap -p- -sS --open -oN /dev/null "$TARGET" 2>/dev/null; then
    SCAN_TYPE="-sS"
    echo -e "${GREEN}[+] SYN scan enabled.${RESET}"
else
    SCAN_TYPE="-sT"
    echo -e "${YELLOW}[!] SYN scan failed. Falling back to TCP Connect scan (-sT).${RESET}"
fi

# Run the scan with detailed logging
echo -e "${CYAN}[*] Starting full scan... This may take a while.${RESET}"
nmap -p- $SCAN_TYPE -sU -sV --version-intensity 9 \
    -O -A -Pn \
    --min-rate 1000 \
    --max-retries 3 \
    --open \
    -T4 \
    -f --mtu 16 \
    -D RND:10 \
    --spoof-mac 00:11:22:33:44:55 \
    --randomize-hosts \
    --badsum \
    -oN "$OUTPUT" \
    "$TARGET" | tee "$OUTPUT"

# Display completion message
echo -e "${GREEN}[+] Scan completed!${RESET}"
echo -e "${YELLOW}[+] Results saved in ${GREEN}$OUTPUT${RESET}"
