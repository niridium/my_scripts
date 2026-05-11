RSYNC_OPTS="-Parvhiz --delete"
REMOTE_DIR="$1:/storage/Backups/vega/"
LOCAL_BASE="/home/nixy"

# Check if rsync is installed
if ! command -v rsync &>/dev/null; then
    echo "Error: rsync is not installed."
    exit 1
fi

# Check if at least one argument (remote host) is provided
if [[ $# -lt 1 ]]; then
    echo "Usage: ./sync-server.sh [remote-host] [remote-path (optional)]"
    exit 1
fi

# Check if sync-files.txt exists in current directory
if [[ ! -f "sync-files.txt" ]]; then
    echo "Error: sync-files.txt not found in the current directory."
    exit 1
fi

# Run rsync
rsync ${RSYNC_OPTS} --files-from=${LOCAL_BASE}/sync-files.txt ${LOCAL_BASE}/ "$REMOTE_DIR"
