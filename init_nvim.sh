#!/bin/bash

# Define colors for logging
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Define the Neovim directories and files
CONFIG_DIR="$HOME/.config/nvim"
INIT_LUA="$CONFIG_DIR/init.lua"
PLUGINS_LUA="$CONFIG_DIR/lua/plugins.lua"
LUA_DIR="$CONFIG_DIR/lua"
PACKER_DIR="$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"

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

# Function to create a directory if it does not exist
create_dir() {
  if [ ! -d "$1" ]; then
    log "WARNING" "Creating directory: $1"
    mkdir -p "$1"
    if [ $? -eq 0 ]; then
      log "SUCCESS" "Successfully created: $1"
    else
      log "ERROR" "Failed to create: $1"
    fi
  else
    log "SUCCESS" "Directory already exists: $1"
  fi
}

# Function to create a file with content if it does not exist
create_file() {
  if [ ! -f "$1" ]; then
    log "WARNING" "Creating file: $1"
    echo "$2" > "$1"
    if [ $? -eq 0 ]; then
      log "SUCCESS" "Successfully created: $1"
    else
      log "ERROR" "Failed to create: $1"
    fi
  else
    log "SUCCESS" "File already exists: $1"
  fi
}

# Function to install Packer if it is not installed
install_packer() {
  if [ ! -d "$PACKER_DIR" ]; then
    log "WARNING" "Installing Packer..."
    git clone --depth 1 https://github.com/wbthomason/packer.nvim "$PACKER_DIR"
    if [ $? -eq 0 ]; then
      log "SUCCESS" "Successfully installed Packer."
    else
      log "ERROR" "Failed to install Packer."
    fi
  else
    log "SUCCESS" "Packer is already installed."
  fi
}

# Basic content for init.lua
INIT_LUA_CONTENT='
-- Set leader key
vim.g.mapleader = " "

-- Load plugins
require("plugins")

-- Basic settings
vim.o.number = true                      -- Show line numbers
vim.o.relativenumber = true              -- Relative line numbers
vim.o.expandtab = true                   -- Use spaces instead of tabs
vim.o.shiftwidth = 4                     -- Number of spaces to use for each step of (auto)indent
vim.o.tabstop = 4                        -- Number of spaces that a <Tab> in the file counts for
vim.o.smartindent = true                 -- Smart indenting
vim.o.wrap = false                       -- Disable line wrapping
vim.o.swapfile = false                   -- Disable swap file
vim.o.backup = false                     -- Disable backup file
vim.o.undofile = true                    -- Enable persistent undo
vim.o.incsearch = true                   -- Incremental search
vim.o.hlsearch = true                    -- Highlight search matches
vim.o.ignorecase = true                  -- Ignore case in search patterns
vim.o.smartcase = true                   -- Smart case
vim.o.scrolloff = 8                      -- Keep 8 lines visible above/below the cursor
vim.o.sidescrolloff = 8                  -- Keep 8 lines visible left/right of the cursor
vim.o.cursorline = true                  -- Highlight the current line
vim.o.termguicolors = true               -- Enable true color support
vim.o.splitright = true                  -- Vertical splits open to the right
vim.o.splitbelow = true                  -- Horizontal splits open below
vim.o.updatetime = 300                   -- Faster completion
vim.o.timeoutlen = 500                   -- Faster mappings
vim.o.clipboard = "unnamedplus"          -- Use system clipboard
vim.o.completeopt = "menuone,noselect"   -- Better completion experience
vim.o.mouse = "a"                        -- Enable mouse support

-- Key mappings
-- These key mappings allow you to quickly perform common actions in normal mode
-- <leader>w saves the current buffer
vim.api.nvim_set_keymap("n", "<leader>w", ":w<CR>", { noremap = true, silent = true })
-- <leader>q quits the current window
vim.api.nvim_set_keymap("n", "<leader>q", ":q<CR>", { noremap = true, silent = true })
-- <leader>x saves and exits the current buffer
vim.api.nvim_set_keymap("n", "<leader>x", ":x<CR>", { noremap = true, silent = true })
-- <leader>h clears search highlights
vim.api.nvim_set_keymap("n", "<leader>h", ":nohlsearch<CR>", { noremap = true, silent = true })
-- Use Ctrl + h/j/k/l to navigate between windows
vim.api.nvim_set_keymap("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })

-- Auto commands
-- These autocommands dynamically adjust Neovim settings based on the current context
vim.cmd([[
  augroup numbertoggle
    autocmd!
    -- Enable relative line numbers when entering a buffer, gaining focus, or leaving insert mode
    autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    -- Disable relative line numbers when leaving a buffer, losing focus, or entering insert mode
    autocmd BufLeave,FocusLost,InsertEnter * set norelativenumber
  augroup END
]])
'

# Basic content for plugins.lua
PLUGINS_LUA_CONTENT='
-- Initialize packer
return require("packer").startup(function()
  -- Packer can manage itself
  use "wbthomason/packer.nvim"

  -- Add more plugins here
end)
'

# Create the necessary directories and files
log "WARNING" "Initializing basic Neovim configuration with Lua..."
create_dir "$CONFIG_DIR"
create_dir "$LUA_DIR"
create_file "$INIT_LUA" "$INIT_LUA_CONTENT"
create_file "$PLUGINS_LUA" "$PLUGINS_LUA_CONTENT"

# Install Packer
install_packer

log "SUCCESS" "Neovim configuration initialization complete."

# Exit the script
exit 0
