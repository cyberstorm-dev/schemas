#!/bin/bash
set -e

if ! command -v buf &> /dev/null; then
    echo "Installing buf CLI..."
    # Use a temporary file and atomic move to prevent race conditions
    TEMP_FILE="/tmp/buf-$$.tmp"
    BUF_PATH="/usr/local/bin/buf"
    
    # Try to create a lock file to serialize installations
    LOCK_FILE="/tmp/buf-install.lock"
    exec 200>"$LOCK_FILE"
    
    # Try to get an exclusive lock with timeout
    if flock -n 200 2>/dev/null; then
        # Check again if buf was installed by another process
        if ! command -v buf &> /dev/null; then
            curl -sSL "https://github.com/bufbuild/buf/releases/latest/download/buf-$(uname -s)-$(uname -m)" -o "$TEMP_FILE"
            chmod +x "$TEMP_FILE"
            
            # Atomic move to prevent race condition
            if [ -w "/usr/local/bin" ]; then
                mv "$TEMP_FILE" "$BUF_PATH"
            else
                sudo mv "$TEMP_FILE" "$BUF_PATH"
            fi
        fi
        flock -u 200
    else
        # Another process is installing, wait for it to complete
        echo "Another buf installation in progress, waiting..."
        flock 200  # Wait for the lock to be released
        flock -u 200
    fi
    
    exec 200>&-  # Close the file descriptor
else
    echo "buf CLI already installed"
fi