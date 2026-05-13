#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR
cd "$(dirname "$0")" || exit

source fluxr.conf

# Stage 1
core_backup() {
    if [[ -z "$REMOTE_HOST" ]]; then
        echo -e "\tBackup directory is: $BACKUP_DIR_1/$hostname/"
        echo -=-

        if $IS_REMOTE; then
            rsync $RSYNC_OPTS "$hostname".include "$hostname":"$ROOT"
            ssh -T "$hostname" <<EOF
                cd $ROOT
                rsync $RSYNC_OPTS --files-from=./"$hostname".include "$ROOT"/ "$BACKUP_DIR_1"/"$hostname"/
EOF
            unset IS_REMOTE
        else
            rsync $RSYNC_OPTS --files-from=./"$hostname".include "$ROOT"/ "$BACKUP_DIR_1"/"$hostname"/
        fi

    else
        echo -e "\tBackup directory is: $REMOTE_HOST:$BACKUP_DIR_1/$hostname/"
        echo -=-
        rsync $RSYNC_OPTS --files-from=./"$hostname".include "$ROOT"/ "$REMOTE_HOST":"$BACKUP_DIR_1"/"$hostname"/
        unset REMOTE_HOST
    fi
}

backup_1() {
    for hostname in "${HOSTNAMES[@]}"; do

        source "$hostname".conf

        echo Host: "$hostname" "-->"
        echo -e "\tDirectory to backup is: $ROOT"

        core_backup
    done
}

# backup_2() {
#     rsync $RSYNC_OPTS $BACKUP_DIR_1 $BACKUP_DIR_2
# }
backup_1
