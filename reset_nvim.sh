#!/bin/bash

# Define colors for logging
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Define the Neovim directories
CONFIG_DIR="$HOME/.config/nvim"
SHARE_DIR="$HOME/.local/share/nvim"
CACHE_DIR="$HOME/.cache/nvim"

# Function to log messages
log() {
  local level="$1"
  local message="$2"
  case "$level" in
    "ERROR")
      echo -e "${RED}[ERROR]${NC} $message"
      ;;
    "WARNING")
      echo -e "${YELLOW}[WARNING]${NC} $message"
      ;;
    "SUCCESS")
      echo -e "${GREEN}[SUCCESS]${NC} $message"
      ;;
    *)
      echo "$message"
      ;;
  esac
}

# Function to remove a directory if it exists
remove_dir() {
  if [ -d "$1" ]; then
    log "WARNING" "Removing directory: $1"
    rm -rf "$1"
    if [ $? -eq 0 ]; then
      log "SUCCESS" "Successfully removed: $1"
    else
      log "ERROR" "Failed to remove: $1" >&2
    fi
  else
    log "ERROR" "Directory does not exist: $1"
  fi
}

# Remove the Neovim directories
log "Resetting Neovim to factory settings..."
remove_dir "$CONFIG_DIR"
remove_dir "$SHARE_DIR"
remove_dir "$CACHE_DIR"
log "Neovim reset complete."

# Exit the script
exit 0

