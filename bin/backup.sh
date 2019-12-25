#!/bin/sh

PROG_NAME=$(basename $0)
USER=""
PASSWORD=""
INPUT_DIR=""
OUTPUT_DIR=""
SCRIPT_DIR=$(dirname $(realpath "$0"))

while getopts u:p:i:o: OPTION
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

if [ ! -d "$OUTPUTDIR" ]; then
    mkdir -p $OUTPUTDIR
fi

echo "Backing up sites and config"
cd $INPUT_DIR;
tar -zcf "$TEMP_SITES_BACKUP_DIR/sites.tar.gz" '.'
tar -zcf "$TEMP_NGINX_CONFIG_DIR/configs.tar.gz" "/etc/nginx/sites-available"

echo "Backing up databases"
#This will backup all my databases
#Modify ‘backup_username’ and ‘PASSWORD’ accordingly

sh $SCRIPT_DIR/dump-all-databases.sh  -u $USER -p $PASSWORD -o $TEMP_MYSQL_DATABASE_BACKUP_DIR -z

cd $TEMP_DIR
tar -cf "$OUTPUT_DIR/$DATE_NAME.tar" $DATE_NAME
rm -rf $TEMP_BACKUP_DIR

OLD_BACKUP_FILES=`ls $OUTPUT_DIR -t | tail -n +11`

if [ -n "$OLD_BACKUP_FILES" ]
then
    echo "Removing old backup files $OLD_BACKUP_FILES"
    rm $OUTPUT_DIR/$OLD_BACKUP_FILES
fi
