#!/usr/bin/env bash
set -euo pipefail

# --- Configuration ---
INSTALL_DIR="$HOME/.local/share/tmoe"
TARGET_FILE="$INSTALL_DIR/tmoe"
REMOTE_URL="https://raw.githubusercontent.com/GaJe48/tmoe/master/tmoe"
BIN_DIR="${PREFIX}/bin"
SYMLINK_PATH="$BIN_DIR/tmoe"

# --- Helper Functions ---
log_info() { echo -e "\033[32m[INFO]\033[0m $1" >&2; }
log_error() { echo -e "\033[31m[ERROR]\033[0m $1" >&2; }

# --- Main Installation Logic ---
main() {
    # 1. Dependency Check
    if ! command -v curl &>/dev/null; then
        pkg install -y curl || { apt update && apt install -y curl; } || { log_error "curl is required but not installed."; exit 1; }
    fi

    # 2. Prepare Directories
    if [[ ! -d "$INSTALL_DIR" ]]; then
        log_info "Creating target directory: $INSTALL_DIR"
        mkdir -p "$INSTALL_DIR"
    fi

    if [[ ! -d "$BIN_DIR" ]]; then
        log_info "Creating bin directory: $BIN_DIR"
        mkdir -p "$BIN_DIR"
    fi

    # 3. Download Script
    log_info "Downloading tmoe from $REMOTE_URL..."
    if curl -fsSL -o "$TARGET_FILE" "$REMOTE_URL"; then
        chmod +x "$TARGET_FILE"
        log_info "Download successful. Made executable."
    else
        log_error "Failed to download file."
        exit 1
    fi

    # 4. Create Symlink
    log_info "Creating symlink at $SYMLINK_PATH..."
    ln -sf "$TARGET_FILE" "$SYMLINK_PATH"
    log_info "Symlink created."

    log_info "Installation complete! Run 'tmoe' to get started."
}

main "$@"
