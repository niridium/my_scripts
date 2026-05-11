RSYNC_OPTS="-Parvhiz --delete"
REMOTE_DIR="/home/nixy/mnt/Server_Backup/"
LOCAL_BASE="$1:/storage"

# Run rsync
rsync ${RSYNC_OPTS} --files-from=${LOCAL_BASE}/sync-drive.txt ${LOCAL_BASE}/ "$REMOTE_DIR"
