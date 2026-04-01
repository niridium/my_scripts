cd $(dirname $0)


if [[ ! -f /home/genty/bash_scripts/config/upsys.conf ]]
then
	echo "Configuration file not found, you can find a sample at 'config' directory"
	exit 2
fi

source config/upsys.conf

GREEN="\e[32m"
YELLOW="\e[33m"
ENDCOLOR="\e[0m"

BEFORE=$(df --output=source,used,size,pcent,fstype -t ext4 -t vfat -t xfs -H --total)

echo ">>> Pre-backup..."

./backupsys.sh

echo ">>> Preparing..."

rm -rvf /var/tmp/portage/* /var/cache/edb/*

emerge --moo

echo ">>> Syncing content..."

eix-sync

echo ">>> Looking for updates..."

emerge -avuND @world

if [[ $(echo $?) != 0 ]]
then
	echo -e "${YELLOW}*** Update halted!"
	exit 1
fi

smart-live-rebuild -q

echo ">>> Cleaning..."

./cleansys.sh

echo ">>> Post-backup..."

./backupsys.sh

echo ">>> Deduplicating..."

duperemove -rdh --hashfile=config/update.hash $DEDUPE_DIRECTORIES

echo -e "${YELLOW}*** Check entries:${ENDCOLOR}"

eix-test-obsolete -q
emaint merges --check
glsa-check -t affected

echo -e "${YELLOW}>>> Storage overview:${ENDCOLOR}"
echo "> Before update:

$BEFORE

> After update:
"

df --output=source,used,size,pcent,fstype -t ext4 -t vfat -t xfs -H --total

echo -e "${GREEN}>>> Update completed${ENDCOLOR}"
