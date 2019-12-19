#!/bin/sh

PROG_NAME=$(basename $0)
USER=""
PASSWORD=""
INPUT_DIR=""
OUTPUT_DIR=""

while getopts i:o: OPTION
do
    case ${OPTION} in
        u) USER=${OPTARG};;
        p) PASSWORD=${OPTARG};;
        i) INPUT_DIR=${OPTARG};;
        o) OUTPUT_DIR=${OPTARG};;
        ?) echo "Usage: ${PROG_NAME} [ -u mysql_username -p mysql_password -i input_dir -o output_dir ]"
           exit 2;;
    esac
done

#Variable with current date and time (for the file name)
DATE_NAME=$(date +'%Y-%m-%d-%H-%M-%S')

#The temp location to copy all files
TEMP_DIR="/tmp"
TEMP_BACKUP_DIR="$TEMP_DIR/$DATE_NAME"
TEMP_SITES_BACKUP_DIR="$TEMP_BACKUP_DIR/sites"
TEMP_NGINX_CONFIG_DIR="$TEMP_BACKUP_DIR/configs/nginx"
TEMP_MYSQL_DATABASE_BACKUP_DIR="$TEMP_BACKUP_DIR/databases"

#Create the directories above
mkdir -p $TEMP_SITES_BACKUP_DIR
mkdir -p $TEMP_NGINX_CONFIG_DIR
mkdir -p $TEMP_MYSQL_DATABASE_BACKUP_DIR

echo "Backing up sites and config"
tar -zcf "$TEMP_SITES_BACKUP_DIR/sites.tar.gz" $INPUT_DIR
tar -zcf "$TEMP_NGINX_CONFIG_DIR/configs.tar.gz" "/etc/nginx/sites-available"

echo "Backing up databases"
#This will backup all my databases
#Modify ‘backup_username’ and ‘PASSWORD’ accordingly
#mysqldump -u backup_username -pPASSWORD --all-databases &gt; "$TEMP_MYSQL_DATABASE_BACKUP_DIR_URL/databases.sql"


tar -cf "$OUTPUT_DIR/$DATE_NAME.tar" $TEMP_BACKUP_DIR
rm -rf $TEMP_BACKUP_DIR

OLD_BACKUP_FILES=`ls $OUTPUT_DIR -t | tail -n +11`

if [ -n "$OLD_BACKUP_FILES" ]
then
    echo "Removing old backup files $OLD_BACKUP_FILES"
    rm $OUTPUT_DIR/$OLD_BACKUP_FILES
fi
