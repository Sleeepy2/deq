#!/bin/bash
# ------------------------------------------------------------------------------
# Name:        deq-update.sh
# Description: Update deq dashboard with one click script.
# Author:      codedbyistvan
# Tested on:   Ubuntu 24.04 (LXC on Proxmox)
# Requirements: wget, unzip
# ------------------------------------------------------------------------------

set -e  # Stop the script if any command fails


# Configuration (adjust these)
WORKDIR="/home"
ZIP_NAME="deq.zip"
INSTALL_DIR="deq"
DOWNLOAD_URL="https://github.com/deqrocks/deq/releases/latest/download/deq.zip"
DEQ_HOST="" #leave blank for default - default is your ip adress
DEQ_PORT="" #leave blank for default is 5050


# Script logic

echo "Moving to Workdir directory"
cd "$WORKDIR"

# Check if deq.zip and deq folder already exists
if [ -f "$ZIP_NAME" ]; then
    echo "Removing existing archive"
    rm -f "$ZIP_NAME"
fi
if [ -d "$INSTALL_DIR" ]; then
    echo "Removing existing installation directory"
    rm -rf "$INSTALL_DIR"
fi


echo "Downloading DEQ package"
wget -q --show-progress "$DOWNLOAD_URL"

echo "Extracting package"
unzip -q "$ZIP_NAME" -d "$INSTALL_DIR"

echo "Entering installation directory"
cd "$INSTALL_DIR"

echo "Running installer"
printf "y\n%s\n%s\n" "$DEQ_HOST" "$DEQ_PORT" | sudo ./install.sh >/dev/null

# printf "y\n\n\n" | sudo ./install.sh

echo "DEQ installation completed successfully"